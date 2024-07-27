import dash
from dash import dcc, html
from dash.dependencies import Input, Output
import plotly.express as px
import pandas as pd

# Carregar dados dos arquivos CSV com a codificação correta
sales_data = pd.read_csv('doc/dashboard/ft_FactSales.csv', encoding='latin1')
order_details = pd.read_csv('doc/dashboard/oder_details.csv', encoding='latin1')
sales_summary = pd.read_csv('doc/dashboard/view_SalesSummary.csv', encoding='latin1')
categories = pd.read_csv('doc/dashboard/categories.csv', encoding='latin1')
employees = pd.read_csv('doc/dashboard/employee.csv', encoding='latin1')
products = pd.read_csv('doc/dashboard/products.csv', encoding='latin1')

# Adicionar coluna fictícia de Region
sales_summary['Region'] = sales_summary['Cliente'].apply(lambda x: 'Region A' if 'A' in x else 'Region B')

# Mesclar dados e resolver conflitos de nomes de colunas
merged_data = sales_data.merge(products, on='ProductID', suffixes=('_sales', '_product'))
merged_data = merged_data.merge(categories, on='CategoryID')
merged_data = merged_data.merge(employees, on='EmployeeID')

# Renomear colunas para manter consistência
merged_data['ProductName'] = merged_data['ProductName_sales']

# Função para criar gráfico de vendas por produto
def create_sales_by_product_chart(df):
    product_sales = df.groupby('ProductName').agg({'Revenue': 'sum'}).reset_index()
    fig = px.bar(product_sales, x='ProductName', y='Revenue', title="Sales by Product")
    return fig

# Função para criar gráfico de vendas por região
def create_sales_by_region_chart(df):
    region_sales = sales_summary.groupby('Region').agg({'TotalVendas': 'sum'}).reset_index()
    fig = px.bar(region_sales, x='Region', y='TotalVendas', title="Sales by Region")
    return fig

# Função para criar gráfico de vendas ao longo do tempo
def create_sales_over_time_chart(df):
    df['OrderDate'] = pd.to_datetime(df['OrderDate'])
    sales_over_time = df.groupby('OrderDate').agg({'Revenue': 'sum'}).reset_index()
    fig = px.line(sales_over_time, x='OrderDate', y='Revenue', title="Sales Over Time")
    return fig

# Função para criar gráfico dos top 10 clientes
def create_top_customers_chart(df):
    top_customers = df.groupby('CustomerID').agg({'Revenue': 'sum'}).nlargest(10, 'Revenue').reset_index()
    fig = px.bar(top_customers, x='CustomerID', y='Revenue', title="Top 10 Customers")
    return fig

# Função para criar gráfico das melhores categorias
def create_top_categories_chart(df):
    top_categories = df.groupby('CategoryName').agg({'Revenue': 'sum'}).reset_index()
    fig = px.bar(top_categories, x='CategoryName', y='Revenue', title="Top Categories")
    return fig

# Layout do Dash
app = dash.Dash(__name__)

app.layout = html.Div(
    style={'backgroundColor': '#ADD8E6', 'padding': '20px'},
    children=[
        html.Img(src='assets/supremeats-logo.png', style={'width': '200px', 'display': 'block', 'margin-left': 'auto', 'margin-right': 'auto'}),
        html.H1(
            "Sales Dashboard",
            style={'textAlign': 'center'}
        ),
        dcc.DatePickerRange(
            id='date-picker-range',
            start_date=sales_data['OrderDate'].min(),
            end_date=sales_data['OrderDate'].max(),
            display_format='YYYY-MM-DD'
        ),
        dcc.Dropdown(
            id='product-dropdown',
            options=[{'label': prod, 'value': prod} for prod in merged_data['ProductName'].unique()],
            value=merged_data['ProductName'].unique().tolist(),
            multi=True,
            placeholder="Select Products"
        ),
        dcc.Dropdown(
            id='region-dropdown',
            options=[{'label': region, 'value': region} for region in sales_summary['Region'].unique()],
            value=sales_summary['Region'].unique().tolist(),
            multi=True,
            placeholder="Select Regions"
        ),
        dcc.Graph(id='sales-by-product-chart'),
        dcc.Graph(id='sales-by-region-chart'),
        dcc.Graph(id='sales-over-time-chart'),
        dcc.Graph(id='top-customers-chart'),
        dcc.Graph(id='top-categories-chart')
    ]
)

# Callbacks para atualizar os gráficos com base nos filtros
@app.callback(
    [
        Output('sales-by-product-chart', 'figure'),
        Output('sales-by-region-chart', 'figure'),
        Output('sales-over-time-chart', 'figure'),
        Output('top-customers-chart', 'figure'),
        Output('top-categories-chart', 'figure')
    ],
    [
        Input('date-picker-range', 'start_date'),
        Input('date-picker-range', 'end_date'),
        Input('product-dropdown', 'value'),
        Input('region-dropdown', 'value')
    ]
)
def update_charts(start_date, end_date, selected_products, selected_regions):
    filtered_sales_data = merged_data[
        (merged_data['OrderDate'] >= start_date) & 
        (merged_data['OrderDate'] <= end_date) & 
        (merged_data['ProductName'].isin(selected_products))
    ]
    
    filtered_sales_summary = sales_summary[sales_summary['Region'].isin(selected_regions)]

    return (
        create_sales_by_product_chart(filtered_sales_data),
        create_sales_by_region_chart(filtered_sales_summary),
        create_sales_over_time_chart(filtered_sales_data),
        create_top_customers_chart(filtered_sales_data),
        create_top_categories_chart(filtered_sales_data)
    )

# Rodar o servidor
if __name__ == '__main__':
    app.run_server(debug=True)