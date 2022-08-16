import os
import requests
import yfinance as yf
import pandas as pd
import matplotlib.pyplot as plt
import seaborn
from tqdm.auto import tqdm
from pylab import rcParams
from datetime import datetime
from params.params import customers, costs, discounts, prices_path

def calculate_prices():
    print('hello')
    seaborn.set()
        
    # Подгружаем курсы
    print("Подгружаем курсы")
    df_dict = {}
    for ticker in tqdm(['USDRUB=X', 'EURUSD=X', 'EURRUB=X']):
        df = yf.download(ticker)
        df = df.Close.copy()
        df = df.resample('M').mean()
        df_dict[ticker] = df
        
    # Создадим таблицу с курсами и датой
    print("Создадим таблицу с курсами и датой")
    rate = pd.concat(df_dict.values(), axis=1).reset_index()
    rate.columns =['date','USDRUB', 'EURUSD', 'EURRUB']
    mask = (rate['date'] >= '2019-01-31') & (rate['date'] <= '2022-08-31')
    rate= rate.loc[mask].reset_index()
    rate['month_year'] = rate['date'].dt.to_period('M')
    rate = rate[['month_year','USDRUB','EURUSD', 'EURRUB']]
    
    # Подгружаем котировки каучука
    print("Подгружаем котировки каучука")
    all_dfs = []
    for y in ['2019','2020','2021','2022']:
        for m in ['01','02','03','04','05','06','07','08','09','10','11','12']:
            url = f"https://www.lgm.gov.my/webv2api/api/rubberprice/month={m}&year={y}"
            res = requests.get(url)
            rj = res.json()
            temp_df = pd.json_normalize(rj)
            all_dfs.append(temp_df)
        
        
     # Создаем таблицу с ценой каучука SMR 20
    print("Создаем таблицу с ценой каучука SMR 20")
    df_new=pd.concat(all_dfs)       
    df_smr_20=df_new[df_new.grade == 'SMR 20'].reset_index()
    df_smr_20 = df_smr_20[['date', 'us']]
    df_smr_20.columns = ['date','rubber_USD']
    df_smr_20.date=pd.to_datetime(df_smr_20.date)
    df_smr_20['month_year'] = df_smr_20['date'].dt.to_period('M')
    df_smr_20['rubber_USD'] = df_smr_20['rubber_USD'].astype(float)
    df_smr_20_agg=df_smr_20.groupby('month_year').agg({'rubber_USD':'mean'}).reset_index()
    

    
    
    # Объединим две таблицы в одну
    print("Объединим две таблицы в одну")
    result = rate.merge(df_smr_20_agg, on=["month_year"])

    # Рассчитываем цены
    print("Рассчитываем цены")
    result['MWP_PRICE_EUR'] = result.rubber_USD * (1/result.EURUSD) + costs.get('PRODUCTION_COST') #затраты на производство в евро
    result['MWP_PRICE_USD'] = result.rubber_USD + costs.get('PRODUCTION_COST') * result.EURUSD #затраты на производство в долларах
    result['MWP_PRICE_EUR_EU'] = result['MWP_PRICE_EUR'] + costs.get('EU_LOGISTIC_COST_EUR') # общие затраты для Европы
    result['MWP_PRICE_USD_CN'] = result['MWP_PRICE_USD'] + costs.get('CN_LOGISTIC_COST_USD') # общие затраты для Китая
    result['MWP_PRICE_EUR_EU_MA'] = result.MWP_PRICE_EUR_EU.rolling(window=3).mean() #скользящее среднее с окном 3


    # Создаем отдельный файл для каждого из клиентов


    rcParams['figure.figsize'] = 15,7

    print("Готовим отдельный файл для клиентов")
    for client, v in customers.items():

        # Создаем директорию и путь к файлу
        client_price_path = os.path.join(prices_path, f"{client.lower()}")
        if not os.path.exists(client_price_path ):
            os.makedirs(client_price_path)

        calculation_date = datetime.today().date().strftime(format="%d%m%Y")
        client_price_file_path = os.path.join(client_price_path, f'{client}_rubber_price_{calculation_date}.xlsx')

        location = v.get('location')
        disc = 0.0
        if v.get('location') == "EU":
            fl = 0
            for k_lim, discount_share in discounts.items():
                if v.get('volumes') > k_lim:
                    continue
                else:
                    disc = discount_share
                    fl = 1
                    break
            if fl == 0:
                disc = discounts.get(max(discounts.keys()))

            if v.get('formula') == 'monthly':
                client_price = result['MWP_PRICE_EUR_EU'].mul((1 - disc)).add(costs.get('EU_LOGISTIC_COST_EUR')).round(2)
            elif v.get('formula') == 'moving_average':
                client_price = result['MWP_PRICE_EUR_EU_MA'].mul((1 - disc)).add(costs.get('EU_LOGISTIC_COST_EUR')).round(2)

        elif v.get('location') == 'CN':
            fl = 0
            for k_lim, discount_share in discounts.items():
                if v.get('volumes') > k_lim:
                    continue
                else:
                    disc = discount_share
                    fl = 1
                    break
            if fl == 0:
                disc = discounts.get(max(discounts.keys()))

            client_price = result['MWP_PRICE_USD_CN'].mul((1 - disc)).add(costs.get('CN_LOGISTIC_COST_USD')).round(2)
        print(client_price.head())
        with pd.ExcelWriter(client_price_file_path, engine='xlsxwriter') as writer:
            client_price.to_excel(writer, sheet_name='price')

            # Добавляем график с ценой
            plot_path = f'{client}_wbp.png'
            plt.title('Цена rubber(DDP)', fontsize=16, fontweight='bold')
            plt.plot(client_price)
            plt.savefig(plot_path)
            plt.close()

            worksheet = writer.sheets['price']
            worksheet.insert_image('C2', plot_path)

        print(f"{client} готов")

    print("Удаляем ненужные файлы")
    for k, v in customers.items():
        if os.path.exists(f"{k}_wbp.png"):
            os.remove(f"{k}_wbp.png")

    print("Работа завершена!")

if __name__ == "__main__":
    calculate_prices()    