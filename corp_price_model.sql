view: corprisk {
  derived_table: {
    sql:  SELECT * FROM ML.PREDICT(MODEL `bi-model-development.looker_FINAL.risk_corp_model`,
    (
    SELECT
    OFFERING_DATE, OFFERING_AMT, OFFERING_PRICE, PRINCIPAL_AMT, MATURITY,
    COUPON, DATED_DATE, FIRST_INTEREST_DATE, LAST_INTEREST_DATE,
    NCOUPS, T_DVolume, T_Yld_Pt,
    ((CASE WHEN {% parameter Yield_Parameter %} IS NULL THEN ((YIELD * POWER(4.16508023e+01, 0.5)) + 5.25625364e+00)
    ELSE {% parameter Yield_Parameter %}
    END) - 5.25625364e+00)/POWER(4.16508023e+01, 0.5) AS YIELD,
    ((CASE WHEN {% parameter Price_EOM_Parameter %} IS NULL THEN ((PRICE_EOM * POWER(1.76568368e+02, 0.5)) + 1.04157195e+02)
    ELSE {% parameter Price_EOM_Parameter %}
    END) - 1.04157195e+02)/POWER(1.76568368e+02, 0.5) AS PRICE_EOM,
    ((CASE WHEN {% parameter T_Volume_Parameter %} IS NULL THEN ((T_Volume * POWER(1.46914264e+16, 0.5)) + 4.04001929e+07)
    ELSE {% parameter T_Volume_Parameter %}
    END) - 4.04001929e+07)/POWER(1.46914264e+16, 0.5) AS T_Volume,
    ((CASE WHEN {% parameter Duration_Parameter %} IS NULL THEN ((DURATION * POWER(1.75036897e+01, 0.5)) + 5.69104413e+00)
    ELSE {% parameter Duration_Parameter %}
    END) - 5.69104413e+00)/POWER(1.75036897e+01, 0.5) AS DURATION,
    ((CASE WHEN {% parameter Amount_Outstanding_Parameter %} IS NULL THEN ((AMOUNT_OUTSTANDING * POWER(4.53987950e+09, 0.5)) + 3.88462634e+03)
    ELSE {% parameter Amount_Outstanding_Parameter %}
    END) - 3.88462634e+03)/POWER(4.53987950e+09, 0.5) AS AMOUNT_OUTSTANDING,
    GAP, COUPMONTH, COUPAMT, COUPACC, MULTICOUPS, RET_EOM, TMT, REMCOUPS, CUSIP
    FROM `bi-model-development.looker_FINAL.risk_corp_dataset`
    WHERE CUSIP = "{% parameter CUSIP_Parameter %}"
    LIMIT 1
    )
    )
 ;;
  }

  parameter: CUSIP_Parameter {
    type: unquoted
  }

  parameter: Yield_Parameter {
    type:  number
  }

  parameter: Price_EOM_Parameter {
    type:  number
  }

  parameter: T_Volume_Parameter {
    type:  number
  }

  parameter: Duration_Parameter {
    type:  number
  }

  parameter: Amount_Outstanding_Parameter {
    type:  number
  }

  # measure: count {
  #   type: count
  #   drill_fields: [detail*]
  # }

  # dimension: offering_date {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.OFFERING_DATE * POWER(4.83674485e+09, 0.5)) + 2.00588090e+07) ;;
  # }

  # dimension: offering_amt {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.OFFERING_AMT * POWER(3.49932668e+11, 0.5)) + 5.66443795e+05) ;;
  # }

  # dimension: offering_price {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.OFFERING_PRICE * POWER(1.13448246e+01, 0.5)) + 9.94486494e+01) ;;
  # }

  # dimension: principal_amt {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.PRINCIPAL_AMT * POWER(1.48101411e+07, 0.5)) + 1.11366285e+03) ;;
  # }

  # dimension: maturity {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.MATURITY * POWER(1.21329523e+10, 0.5)) + 2.02025776e+07) ;;
  # }

  # dimension: coupon {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.COUPON * POWER(4.65542820e+00, 0.5)) + 5.85301934e+00);;
  # }

  # dimension: dated_date {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.DATED_DATE * POWER(4.82836142e+09, 0.5)) + 2.00584948e+07) ;;
  # }

  # dimension: first_interest_date {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.FIRST_INTEREST_DATE * POWER(4.82836142e+09, 0.5)) + 2.00632415e+07) ;;
  # }

  # dimension: last_interest_date {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.LAST_INTEREST_DATE * POWER(1.21232257e+10, 0.5)) + 2.01972594e+07) ;;
  # }

  # dimension: n_coups {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.NCOUPS * POWER(1.05518897e+00, 0.5)) + 2.07670471e+00) ;;
  # }

  # dimension: amount_outstanding {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.AMOUNT_OUTSTANDING * POWER(4.53987950e+09, 0.5)) + 3.88462634e+03) ;;
  # }

  # dimension: T_Volume {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.T_Volume * POWER(1.46914264e+16, 0.5)) + 4.04001929e+07) ;;
  # }

  # dimension: T_DVolume {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.T_DVolume * POWER(1.47630034e+16, 0.5)) + 4.07272332e+07) ;;
  # }

  # dimension: T_Yld_Pt {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.T_Yld_Pt * POWER(1.22744635e+05, 0.5)) + 5.98404571e+00) ;;
  # }

  # dimension: Yield {
  #   type: number
  #   value_format: "0.###"
  #   can_filter: no
  #   sql: ((${TABLE}.YIELD * POWER(4.16508023e+01, 0.5)) + 5.25625364e+00) ;;
  # }

  # dimension: price_EOM {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.PRICE_EOM  * POWER(1.76568368e+02, 0.5)) + 1.04157195e+02) ;;
  # }

  # dimension: gap {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.GAP * POWER(6.72946749e-04, 0.5)) + 1.00008512e+00) ;;
  # }

  # dimension: coup_amt {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.COUPAMT * POWER(3.48220777e+03, 0.5)) + 5.94412041e+01) ;;
  # }

  # dimension: coup_month {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.COUPMONTH * POWER(4.91979537e-01, 0.5)) + 1.37430649e+00) ;;
  # }

  # dimension: coup_acc {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.COUPACC * POWER(1.14116520e+00, 0.5)) + 1.51487616e+00) ;;
  # }

  # dimension: multicoups {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.MULTICOUPS * POWER(1.12426450e-05, 0.5)) + 1.00000482e+00)  ;;
  # }

  # dimension: ret_eom {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.RET_EOM * POWER(1.85478976e+01, 0.5)) + 6.14558097e-01) ;;
  # }

  # dimension: tmt {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.TMT * POWER(9.31015353e+01, 0.5)) + 9.02212106e+00) ;;
  # }

  # dimension: remcoups {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.REMCOUPS * POWER( 6.01969675e+02, 0.5)) + 1.94454168e+01) ;;
  # }

  # dimension: duration {
  #   type: number
  #   can_filter: no
  #   sql: ((${TABLE}.DURATION * POWER(1.75036897e+01, 0.5)) + 5.69104413e+00) ;;
  # }

  dimension: predicted_class {
    type: number
    hidden: yes
    can_filter: no
    sql: ${TABLE}.predicted_R_FR ;;
  }

  # dimension: evaluated_risk {
  #   type: string
  #   sql:
  #   CASE WHEN ${predicted_class} = 4 THEN "Low"
  #   WHEN ${predicted_class} = 2 OR ${predicted_class} = 3 THEN "Medium"
  #   WHEN ${predicted_class} = 1 OR ${predicted_class} = 0 THEN "High"
  #   ELSE NULL END
  #   ;;
  # }
  
  measure: amount_outstanding {
    type: number
    value_format: "0.###"
    can_filter: no
    sql: ((${TABLE}.AMOUNT_OUTSTANDING * POWER(4.53987950e+09, 0.5)) + 3.88462634e+03) ;;
  }
  
  measure: T_Volume {
    type: number
    value_format: "0"
    can_filter: no
    sql: ((${TABLE}.T_Volume * POWER(1.46914264e+16, 0.5)) + 4.04001929e+07) ;;
  }
  
  measure: Yield {
    type: number
    value_format: "0.###"
    can_filter: no
    sql: ((${TABLE}.YIELD * POWER(4.16508023e+01, 0.5)) + 5.25625364e+00) ;;
  }

  measure: price_EOM {
    type: number
    value_format: "0.#"
    can_filter: no
    sql: ((${TABLE}.PRICE_EOM  * POWER(1.76568368e+02, 0.5)) + 1.04157195e+02) ;;
  }
  
  measure: duration {
    type: number
    value_format: "0.##"
    can_filter: no
    sql: ((${TABLE}.DURATION * POWER(1.75036897e+01, 0.5)) + 5.69104413e+00) ;;
  }
  
  measure: evaluated_risk {
    type: string
    can_filter: no
    sql:
    CASE WHEN ${predicted_class} = 4 THEN "Low"
    WHEN ${predicted_class} = 2 OR ${predicted_class} = 3 THEN "Medium"
    WHEN ${predicted_class} = 1 OR ${predicted_class} = 0 THEN "High"
    ELSE NULL END
    ;;
  }

  set: detail {
    fields: [
      duration, amount_outstanding, Yield, price_EOM, T_Volume
    ]
  }
}
