import dash
from dash import html, dcc, Output, Input
import plotly.graph_objs as go
import pandas as pd
from statsmodels.tsa.statespace.sarimax import SARIMAX

# Carrega os dados
file_path = 'ML\\ft_FactSales.csv' 
df = pd.read_csv(file_path, encoding='latin1')

# Converte a data e define como índice para previsão de séries temporais
df['OrderDate'] = pd.to_datetime(df['OrderDate'])
df.set_index('OrderDate', inplace=True)

# Agrega os dados por mês para previsões mensais
monthly_data = df.resample('M').sum()

# Prepara o modelo SARIMAX
model = SARIMAX(monthly_data['Revenue'], order=(1, 0, 1), seasonal_order=(1, 1, 1, 12))
model_fit = model.fit(disp=False)

app = dash.Dash(__name__)

app.layout = html.Div([
    html.H1("Revenue Prediction Dashboard"),
    html.Button('Predict Next 12 Months Revenue', id='predict', n_clicks=0),
    html.H3('Predicted Revenue:'),
    html.Div(id='prediction_output', style={'font-size': '24px', 'color': 'blue'})
])

@app.callback(
    Output('prediction_output', 'children'),
    Input('predict', 'n_clicks')
)
def update_output(n_clicks):
    if n_clicks > 0:
        # Pega a última data disponível dos dados
        last_date = monthly_data.index.max()
        # Faz a previsão para os próximos 12 meses
        future = model_fit.get_forecast(steps=12)
        predictions = future.predicted_mean
        # Cria um gráfico com as previsões
        fig = go.Figure(data=[
            go.Bar(x=predictions.index, y=predictions, name='Predicted Revenue')
        ])
        fig.update_layout(title='Predicted Revenue for the Next 12 Months',
                          xaxis_title='Month',
                          yaxis_title='Revenue')
        return dcc.Graph(figure=fig)
    return ''

if __name__ == '__main__':
    app.run_server(debug=True)
