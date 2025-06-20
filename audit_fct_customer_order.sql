{% set old_relation = adapter.get_relation(
    database=target.database,
    schema="DBT_STHANGAVEL",
    identifier="legacy_customer_orders",
) -%}

{% set dbt_relation = ref("fct_customer_orders") %}

{% if execute %}

    {{
        audit_helper.compare_relations(
            a_relation=old_relation, b_relation=dbt_relation, primary_key="order_id"
        )
    }}

{% endif %}
