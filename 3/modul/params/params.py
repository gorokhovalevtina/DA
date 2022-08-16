# Затраты на производство
PRODUCTION_COST = 400  # (EUR)

# Расходы на логистику
EU_LOGISTIC_COST_EUR = 30  # в Европу в евро
CN_LOGISTIC_COST_USD = 130  # в Китай в долларах

costs = {
    'PRODUCTION_COST': PRODUCTION_COST,
    'EU_LOGISTIC_COST_EUR': EU_LOGISTIC_COST_EUR,
    'CN_LOGISTIC_COST_USD': CN_LOGISTIC_COST_USD,
}

# Справочная информация по клиентам(объемы, локации, комментарии)
customers = {
    'Monty':{
        'location':'EU',
        'volumes':200,
        'formula':'moving_average'
    },

    'Triangle':{
        'location':'CN',
        'volumes': 30,
        'formula': 'monthly'
    },
    'Stone':{
        'location':'EU',
        'volumes': 150,
        'formula': 'moving_average'
    },
    'Poly':{
        'location':'EU',
        'volumes': 70,
        'formula': 'monthly'
    }
}
# Скидки
discounts = {100: 0.01, 300: 0.05, 301: 0.1}
#
prices_path = 'clients_rubber_prices'

