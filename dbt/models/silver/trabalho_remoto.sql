-- import dos dados: exctract da fonte
with source as (
    select
        "jobTitle",
        "companyName",
        "jobType",
        "jobGeo",
        "jobLevel",
        "annualSalaryMin",
        "annualSalaryMax",
        "salaryCurrency"
    from {{ source('PROJETO_DBT', 'listagem_trabalhos_remotos') }}
),

-- renamed : inserir todas as transformações

renamed as (
    select
        "jobTitle" as titulo_vaga,
        "companyName" as nome_empresa,
        "jobType" as tipo_trabalho,
        "jobGeo" as localizacao,
        "jobLevel" as senioridade,
        cast("annualSalaryMin" as float) as minimo_salario_anual,
        cast("annualSalaryMax" as float) as max_salario_anual,
        "salaryCurrency" as moeda
    from source
     
),

-- final: select final

final as (
    select
        titulo_vaga,
        nome_empresa,
        tipo_trabalho,
        localizacao,
        senioridade,
        round(minimo_salario_anual/12, 2) as minimo_salario_mensal,
        minimo_salario_anual,
        round(max_salario_anual/12, 2) as maximo_salario_mensal,
        max_salario_anual,
        moeda
    from renamed
    where minimo_salario_anual != 'NaN'
    or max_salario_anual != 'Nan'
)

select * from final