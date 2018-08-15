import json
import requests


#load data

request = requests.get('https://cex.io/api/last_prices/BTC/EUR/')

loaded_data = request.json()

for current_data in loaded_data['data']:
    if current_data['symbol1'] == 'BTC' and current_data['symbol2'] == 'EUR':
        current_btc_eur = float(current_data['lprice'])
    if current_data['symbol1'] == 'ETH' and current_data['symbol2'] == 'EUR':
        current_eth_eur = float(current_data['lprice'])
    if current_data['symbol1'] == 'ETH' and current_data['symbol2'] == 'BTC':
        current_btc_eth = float(current_data['lprice'])
    if current_data['symbol1'] == 'BTG' and current_data['symbol2'] == 'EUR':
        current_btg_eur = float(current_data['lprice'])
    if current_data['symbol1'] == 'XRP' and current_data['symbol2'] == 'EUR':
        current_xrp_eur = float(current_data['lprice'])
    if current_data['symbol1'] == 'BCH' and current_data['symbol2'] == 'EUR':
        current_bch_eur = float(current_data['lprice'])
    if current_data['symbol1'] == 'DASH' and current_data['symbol2'] == 'EUR':
        current_dash_eur = float(current_data['lprice'])
    if current_data['symbol1'] == 'ZEC' and current_data['symbol2'] == 'EUR':
        current_zec_eur = float(current_data['lprice'])

with open('data.txt') as data_file:
    data = json.load(data_file)

def make_decision(s1, s2, current_price, saved_price):
    print("\nCurrent price {0}/{1}: {2}".format(s1,s2,current_price))
    print("Saved price {0}/{1}: {2}".format(s1,s2,saved_price))
    diff = current_price - saved_price
    percent = int(diff/saved_price * 100)
    print("Difference: {0} ({1}%)".format(diff, percent))
    print("Money inside: ", data[s1] * current_price)



make_decision('BTC', 'EUR', current_btc_eur, float(data["BTC/EUR"]))
make_decision('ETH', 'EUR', current_eth_eur, data["ETH/EUR"])
make_decision('BTC', 'ETH', current_btc_eth, data["ETH/BTC"])
print("BTC/ETC in EUR ", current_btc_eth*current_btc_eur)
#make_decision('BTG', 'EUR', current_btg_eur, data["BTG/EUR"])
#make_decision('XRP', 'EUR', current_xrp_eur,  data["XRP/EUR"])
#make_decision('BCH', 'EUR', current_bch_eur, data["BCH/EUR"])
#make_decision('DASH', 'EUR', current_dash_eur, data["DASH/EUR"])
#make_decision('ZEC', 'EUR', current_zec_eur, data["ZEC/EUR"])

sum = data["BTC"]*current_btc_eur
sum = sum + data["ETH"]*current_eth_eur
sum = sum + data["EUR"]
sum = sum + data["BTG"]*current_btg_eur
sum = sum + data["XRP"]*current_xrp_eur
sum = sum + data["BCH"]*current_bch_eur
sum = sum + data["DASH"]*current_dash_eur
sum = sum + data["ZEC"]*current_zec_eur

print ("\nYou have now:", sum)
