*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}                https://www.calkoo.com/en/vat-calculator
${Browser}            Chrome
${Country}            United Kingdom
${PriceWithoutVAT}    100
${ExpectedVATRate}    20%
${ExpectedPriceIncVAT}    120.00
${ExpectedChartPercentages}    16.7%, 83.3%

*** Test Cases ***
User calculates with given price without VAT
    Open Browser    ${URL}    ${Browser}
    Maximize Browser Window
    Select Country    ${Country}
    ${vat_rates} =    Get VAT Rates
    Verify VAT Rates    ${vat_rates}
    Input Price Without VAT    ${PriceWithoutVAT}
    Verify Calculated Values    ${ExpectedVATRate}    ${ExpectedPriceIncVAT}
    Verify Chart Percentages    ${ExpectedChartPercentages}
    Close Browser

*** Keywords ***
Select Country
    [Arguments]    ${country}
    Select From List By Label    id=country    ${country}

Get VAT Rates
    Wait Until Element Is Visible    xpath=//*[@id="rates-table"]
    ${vat_rates} =    Get Text    xpath=//*[@id="rates-table"]
    [Return]    ${vat_rates}

Verify VAT Rates
    [Arguments]    ${vat_rates}
    Should Contain    ${vat_rates}    5%
    Should Contain    ${vat_rates}    20%
    Should Contain    ${vat_rates}    20% (selected)

Input Price Without VAT
    [Arguments]    ${value}
    Input Text    id=price_without_vat    ${value}

Verify Calculated Values
    [Arguments]    ${vat_rate}    ${price_inc_vat}
    Wait Until Element Is Visible    id=vat
    ${actual_vat_rate} =    Get Text    id=vat
    ${actual_price_inc_vat} =    Get Text    id=price_including_vat
    Should Be Equal As Strings    ${vat_rate}    ${actual_vat_rate}
    Should Be Equal As Strings    ${price_inc_vat}    ${actual_price_inc_vat}

Verify Chart Percentages
    [Arguments]    ${expected_percentages}
    Wait Until Element Is Visible    xpath=//*[@id="chart_div"]/div/div[1]/div/svg/g[2]/path[2]
    ${chart_path} =    Get Text    xpath=//*[@id="chart_div"]/div/div[1]/div/svg/g[2]/path[2]
    Should Be Equal As Strings    ${expected_percentages}    ${chart_path}
