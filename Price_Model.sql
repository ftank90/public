view: pricemodel {

  derived_table: {
    sql: SELECT model.*
    FROM ML.PREDICT(MODEL `bi-model-development.looker_FINAL.price_muni_boosted_model`,
      (
      SELECT
      (cols.Income_Ratio - 4.78707613)/POWER(0.416192260, 0.5) AS Income_Ratio,
      (cols._80th_Percentile_Income - 1.10834510e+05)/POWER(5.46152171e+08, 0.5) AS _80th_Percentile_Income,
      (cols.FIPS - 2.17677827e+04)/POWER(3.15575966e+08, 0.5) AS FIPS,
      (cols.Africa_dem - 1.04641487e+04)/POWER(2.05322957e+08, 0.5) AS Africa_dem,
      (cols.Trade_Date - 7.94418234e+04)/POWER(9.70011616e+04, 0.5) AS Trade_Date,
      ((CASE WHEN {% parameter _10_Year_Treasury_Constant_Maturity_Rate_Percent_Daily_Not_Seasonally_Adjusted_Parameter %} IS NULL THEN cols._10_Year_Treasury_Constant_Maturity_Rate_Percent_Daily_Not_Seasonally_Adjusted
      ELSE {% parameter _10_Year_Treasury_Constant_Maturity_Rate_Percent_Daily_Not_Seasonally_Adjusted_Parameter %}
      END) - 2.38129247e+00)/POWER(2.26253201e-01, 0.5) AS _10_Year_Treasury_Constant_Maturity_Rate_Percent_Daily_Not_Seasonally_Adjusted,
      ((CASE WHEN {% parameter Interest_Rate_of_the_Issue_Traded_Parameter %} IS NULL THEN cols.Interest_rate_of_the_issue_traded
      ELSE {% parameter Interest_Rate_of_the_Issue_Traded_Parameter %}
      END) - 4.21839171e+00)/POWER(1.65615697e+00, 0.5) AS Interest_rate_of_the_issue_traded,
      ((CASE WHEN {% parameter Days_Between_Maturity_Date_and_Trade_Date_Parameter %} IS NULL THEN cols.Days_between_maturity_date_and_trade_date
      ELSE {% parameter Days_Between_Maturity_Date_and_Trade_Date_Parameter %}
      END) - 4.42480705e+03)/POWER(8.97276123e+06, 0.5) AS Days_between_maturity_date_and_trade_date,
      ((CASE WHEN {% parameter The_Yield_Of_The_Trade_Parameter %} IS NULL THEN cols.The_yield_of_the_trade
      ELSE {% parameter The_Yield_Of_The_Trade_Parameter %}
      END) - 2.37509641e+00)/POWER(7.67943277e+00, 0.5) AS The_yield_of_the_trade,
      (cols.Issuer_Industry - 1.05359266e+02)/POWER(5.65820163e+00, 0.5) AS Issuer_Industry,
      (cols.Issue_Size - 1.60207594e+08)/POWER(4.60561611e+16, 0.5) AS Issue_Size,
      ((CASE WHEN {% parameter Maturity_Size_Parameter %} IS NULL THEN cols.MaturitySize
      ELSE {% parameter Maturity_Size_Parameter %}
      END) - 1.88481748e+07)/POWER(1.76399804e+15, 0.5) AS MaturitySize,
      (cols.Price_At_Issue - 1.04254845e+02)/POWER(2.82825359e+02, 0.5) AS Price_At_Issue,
      (cols.Yield_at_Issue - 3.41463484e+00)/POWER(2.02232741e+00, 0.5) AS Yield_at_Issue,
      (cols._85_MAge2 - 2.87041104e+04)/POWER(1.59689889e+09, 0.5) AS _85_MAge2,
      (cols._20_24_MAge2 - 1.16123435e+05)/POWER(2.88425738e+10, 0.5) AS _20_24_MAge2,
      (cols._Proficient - 9.58538532e+01)/POWER(1.50505168e+01, 0.5) AS _Proficient,
      (cols.__Non_Hispanic_White - 5.96917660e+01)/POWER(3.68286386e+02, 0.5) AS __Non_Hispanic_White,
      (cols.Ratings1 - 8.01936341e+01)/POWER(6.23614973e+02, 0.5) AS Ratings1,
      (cols.Ratings2 - 8.02749197e+01)/POWER(6.31857179e+02, 0.5) AS Ratings2,
      (cols.Ratings3 - 8.10222250e+01)/POWER(6.27553773e+02, 0.5) AS Ratings3,
      (cols.Dollar_Price_of_the_Trade) AS Dollar_Price_of_the_Trade,
      (cols.CUSIP) AS CUSIP,
      Issuer_Industry_String, Trade_Date_Time, Maturity_date_of_the_issue_traded
      FROM `bi-model-development.looker_FINAL.price_muni_boosted_training` AS cols
      WHERE CUSIP = "{% parameter CUSIP_Parameter %}"
      )
      ) AS model
      LIMIT 1
;;
  }

  parameter: _10_Year_Treasury_Constant_Maturity_Rate_Percent_Daily_Not_Seasonally_Adjusted_Parameter {
    type: number
  }
  
  parameter: The_Yield_Of_The_Trade_Parameter {
    type: number
  }
  
  parameter: Interest_Rate_of_the_Issue_Traded_Parameter {
    type: number
  }
  
  parameter: Days_Between_Maturity_Date_and_Trade_Date_Parameter {
    type: number
  }

  parameter: Maturity_Size_Parameter {
    type: number
  }

  parameter: CUSIP_Parameter {
    type: unquoted
  }

  # measure: count {
  #   type: count
  #   drill_fields: [detail*]
  # }

  dimension: Income_Ratio {
    type: number
    can_filter: no
    value_format: "0.#########"
    sql: ((${TABLE}.Income_Ratio * POWER(0.416192260, 0.5)) + 4.78707613)  ;;
  }

  dimension: _80th_Percentile_Income {
    type: number
    can_filter: no
    value_format: "0"
    sql: ((${TABLE}._80th_Percentile_Income * POWER(5.46152171e+08, 0.5)) + 1.10834510e+05);;
  }

  dimension: FIPS {
    type: number
    can_filter: no
    value_format: "0"
    sql: ((${TABLE}.FIPS * POWER(3.15575966e+08, 0.5)) + 2.17677827e+04);;
  }

  dimension: Africa_dem {
    type: number
    can_filter: no
    value_format: "0"
    sql: ((${TABLE}.Africa_dem * POWER(2.05322957e+08, 0.5)) + 1.04641487e+04);;
  }

  dimension: Trade_Date {
    type: date_time
    sql: ${TABLE}.Trade_Date_Time ;;
    can_filter: no
    #sql: ((${TABLE}.Trade_Date * POWER(9.70011616e+04, 0.5)) + 7.94418234e+04);;
  }

  dimension: _10_Year_Treasury_Constant_Maturity_Rate_Percent_Daily_Not_Seasonally_Adjusted {
    type: number
    can_filter: no
    value_format: "0.##"
    sql: ((${TABLE}._10_Year_Treasury_Constant_Maturity_Rate_Percent_Daily_Not_Seasonally_Adjusted * POWER(2.26253201e-01, 0.5)) + 2.38129247e+00);;
  }

  dimension: Interest_rate_of_the_issue_traded {
    type: number
    can_filter: no
    value_format: "0.##"
    sql: ((${TABLE}.Interest_rate_of_the_issue_traded * POWER(1.65615697e+00, 0.5)) + 4.21839171e+00);;
  }

  dimension: Maturity_date_of_the_issue_traded {
    type: date_time
    can_filter: no
    value_format: "0"
    sql: ${TABLE}.Maturity_date_of_the_issue_traded;;
  }

  dimension: Days_between_maturity_date_and_trade_date {
    type: number
    can_filter: no
    value_format: "0"
    sql: ((${TABLE}.Days_between_maturity_date_and_trade_date * POWER(8.97276123e+06, 0.5)) + 4.42480705e+03);;
  }

  dimension: The_yield_of_the_trade {
    type: number
    can_filter: no
    value_format: "0.###"
    sql: ((${TABLE}.The_yield_of_the_trade * POWER(7.67943277e+00, 0.5)) + 2.37509641e+00);;
  }

  dimension: Issuer_Industry {
    type: string
    can_filter: no
    sql:  ${TABLE}.Issuer_Industry_String ;;
    #sql: ((${TABLE}.Issuer_Industry * POWER(5.65820163e+00, 0.5)) + 1.05359266e+02);;
  }

  dimension: Issue_Size {
    type: number
    can_filter: no
    value_format: "0"
    sql: ((${TABLE}.Issue_Size * POWER(4.60561611e+16, 0.5)) + 1.60207594e+08);;
  }

  dimension: MaturitySize {
    type: number
    can_filter: no
    value_format: "0.00"
    sql: ((${TABLE}.MaturitySize * POWER(1.76399804e+15, 0.5)) + 1.88481748e+07);;
  }
  dimension: Price_At_Issue {
    type: number
    can_filter: no
    value_format: "0.#######"
    sql: ((${TABLE}.Price_At_Issue * POWER(2.82825359e+02, 0.5)) + 1.04254845e+02);;
  }

  dimension: Yield_at_Issue {
    type: number
    can_filter: no
    value_format: "0.##"
    sql: ((${TABLE}.Price_At_Issue * POWER(2.02232741e+00, 0.5)) + 3.41463484e+00);;
  }

  dimension: _85_MAge2 {
    type: number
    can_filter: no
    value_format: "0"
    sql: ((${TABLE}.Price_At_Issue * POWER(1.59689889e+09, 0.5)) + 2.87041104e+04);;
  }

  dimension: _20_24_MAge2 {
    type: number
    can_filter: no
    value_format: "0"
    sql: ((${TABLE}.Price_At_Issue * POWER(2.88425738e+10, 0.5)) + 1.16123435e+05);;
  }

  dimension: _Proficient {
    type: number
    can_filter: no
    value_format: "0.########"
    sql: ((${TABLE}.Price_At_Issue * POWER(1.50505168e+01, 0.5)) + 9.58538532e+01);;
  }

  dimension: __Non_Hispanic_White {
    type: number
    can_filter: no
    value_format: "0.########"
    sql: ((${TABLE}.Price_At_Issue * POWER(3.68286386e+02, 0.5)) + 5.96917660e+01);;
  }

  dimension: Ratings1 {
    type: number
    can_filter: no
    value_format: "0"
    sql: ((${TABLE}.Price_At_Issue * POWER(6.23614973e+02, 0.5)) + 8.01936341e+01);;
  }

  dimension: Ratings2 {
    type: number
    can_filter: no
    value_format: "0"
    sql: ((${TABLE}.Price_At_Issue * POWER(6.31857179e+02, 0.5)) + 8.02749197e+01);;
  }

  dimension: Ratings3 {
    type: number
    can_filter: no
    value_format: "0"
    sql: ((${TABLE}.Price_At_Issue * POWER(6.27553773e+02, 0.5)) + 8.10222250e+01);;
  }
  
  dimension: predicted_Dollar_Price_of_the_trade {
    
    type: number
    can_filter: no
    value_format: "$0.00"
    sql: ${TABLE}.predicted_Dollar_Price_of_the_trade ;;
  }

  # dimension: Dollar_Price_of_the_Trade {
  #   type: number
  #   sql: ${TABLE}.Dollar_Price_of_the_Trade ;;
  # }

  # dimension: CUSIP {
  #   type: number
  #   sql: ${TABLE}.CUSIP ;;
  # }

  set: detail {
    fields: [
      Income_Ratio, _80th_Percentile_Income, FIPS, Africa_dem, Trade_Date,
      _10_Year_Treasury_Constant_Maturity_Rate_Percent_Daily_Not_Seasonally_Adjusted,
      Interest_rate_of_the_issue_traded,  Days_between_maturity_date_and_trade_date,
      The_yield_of_the_trade, Issuer_Industry,  Issue_Size, MaturitySize, Price_At_Issue,
      Yield_at_Issue, _85_MAge2,  _20_24_MAge2, _Proficient,  __Non_Hispanic_White, Ratings1,
      Ratings2, Ratings3, CUSIP_Parameter
    ]
  }


}
