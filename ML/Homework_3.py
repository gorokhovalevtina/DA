import streamlit as st
import pandas as pd
from sklearn.metrics import mean_absolute_error
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression



st.title('Предсказание курса ЕВРО')

option = st.selectbox(
    'Выберите размер test_size?',
    (0.15, 0.2, 0.3))

if st.button('Показать данные'):
    df = pd.read_excel('EURRUR.xlsx')
    st.dataframe(df)

if st.button('Показать график курса факт/прогноз'):

    df = pd.read_excel('EURRUR.xlsx')
    df.set_index('data', inplace=True)

    def make_features(data, max_lag, rolling_mean_size):
        data['year'] = data.index.year
        data['month'] = data.index.month
        data['day'] = data.index.day
        data['dayofweek'] = data.index.dayofweek
        data['is_weekend'] = data.index.isin([5, 6]) * 1

        for lag in range(1, max_lag + 1):
            data['lag_{}'.format(lag)] = data['curs'].shift(lag)

        data['y_mean'] = data['curs'].shift().rolling(rolling_mean_size).mean().copy()

    make_features(df, 30, 3)

    df.dropna(inplace=True)

    X_train, X_test, y_train, y_test = train_test_split(df.drop('curs', axis=1),
                                                        df.curs,
                                                        shuffle=False,
                                                        test_size=option)

    lr = LinearRegression()
    lr.fit(X_train, y_train)
    pred = lr.predict(X_test)
    st.text('Качество модели ' + str(round(mean_absolute_error(y_test, pred), 2)))

    pred_df = pd.DataFrame(y_test)
    pred_df['pred'] = pred

    st.bar_chart(pred_df)

    st.line_chart(pred_df)

    st.area_chart(pred_df)

