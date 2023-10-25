import { LightningElement, track } from 'lwc';

export default class TakeHomePayCalculator extends LightningElement {

@track salary = 0;
@track takeHomePay = 0;
@track yearlyTakeHomePay = 0;
@track semiAnnualTakeHomePay = 0;
@track monthlyTakeHomePay = 0;
@track biWeeklyTakeHomePay = 0;
@track federalWitholding = 0;
@track yearlyPay = 0;
@track socialSecurityWithholding = 0;
@track medicareWithholding = 0;

medicareRate = 0.0145;
socialSecurityRate = 0.0620;

    // Define federal tax brackets and rates
    federalTaxBrackets = [
        { min: 0, max: 10275, rate: 0.10 },
        { min: 10276, max: 41775, rate: 0.12 },
        { min: 41776, max: 89075, rate: 0.22 },
        { min: 89076, max: 170050, rate: 0.24 },
        { min: 170051, max: 215950, rate: 0.32 },
        { min: 215951, max: 539900, rate: 0.35 },
        { min: 539901, max: Infinity, rate: 0.37 }
    ];

    handleCalculate() {
        // Calculate the Take Home Pay
       this.takeHomePay = this.salary - this.calculateFederalTax() - this.salary * this.medicareRate - this.salary * this.socialSecurityRate;
        //this.takeHomePay = takeHomePay;
        this.yearlyTakeHomePay = this.takeHomePay * 12;
        this.semiAnnualTakeHomePay = this.takeHomePay / 2;
        this.monthlyTakeHomePay = this.takeHomePay;
        this.biWeeklyTakeHomePay = this.takeHomePay / 26;
    }

    calculateFederalTax() {
        // Calculate the federal tax based on the salary
        let federalTax = 0;

        for (const bracket of this.federalTaxBrackets) {
            if (this.salary > bracket.min && this.salary <= bracket.max) {
                federalTax = (bracket.rate * this.salary) - (bracket.min * bracket.rate);
                this.federalWitholding = federalTax.toLocaleString(undefined, { maximumFractionDigits: 2});
                this.yearlyPay = (this.salary - (federalTax + (this.salary * this.socialSecurityRate) + (this.salary * this.medicareRate)));
                break;
            }
        }

        if (this.salary > 0) {
            this.socialSecurityWithholding = (this.salary * this.socialSecurityRate).toFixed(2);
            this.medicareWithholding = (this.salary * this.medicareRate).toFixed(2);
            } else {
                this.socialSecurityWithholding = 0;
                this.medicareWithholding = 0;
            }
            return federalTax;
        }
    

    handleChange(event) {
        // Update the corresponding property based on user input
        const fieldName = event.target.label;
        this[fieldName.toLowerCase()] = parseFloat(event.target.value);
    }
}