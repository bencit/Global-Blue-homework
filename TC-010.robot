#Test will fail cause it's impossible to enter 1.000.000.000 character into the field.

*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}                https://www.calkoo.com/en/vat-calculator
${Browser}            Chrome
${Country}            United Kingdom
${NegativePrice}      -1
${LargeVATValue}      1.000.000.000
${ErrorMessage1}      Negative values are Invalid for a pie chart.
${ErrorMessage2}      Not allowed to enter this amount of numbers into the field.

*** Test Cases ***
Check the error messages 
    Open Browser    ${URL}    ${Browser}
    Maximize Browser Window
    Select Country    ${Country}
    Input Negative Price
    Verify Error Message    ${ErrorMessage1}
    Select VAT Checkbox
    Input Large VAT Value
    Verify Error Message    ${ErrorMessage2}
    Close Browser

*** Keywords ***
Select Country
    [Arguments]    ${country}
    Select From List By Label    id=country    ${country}

Input Negative Price
    Input Text    id=price_without_vat    ${NegativePrice}

Verify Error Message
    [Arguments]    ${expected_message}
    Wait Until Page Contains    ${expected_message}
