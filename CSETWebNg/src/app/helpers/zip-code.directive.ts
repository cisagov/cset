import { Directive, ElementRef, Input, HostListener } from '@angular/core';
import { NgControl, ValidationErrors } from '@angular/forms';

/*
 * Directive to format zip codes on FormControl.
 * This currently only formats US zip codes.  
 */

@Directive({
    selector: '[zipCode]'
})
export class ZipCodeDirective {

    protected hyphenKeyCode: number = 189;
    protected backSpaceKeyCode: number = 8;
    constructor(protected el: ElementRef, protected ngControl: NgControl) { }

    @HostListener('keyup', ['$event'])
    protected onkeyup(event): void {
        const keyCode: number = event.keyCode;
        let value: string = this.ngControl.control.value;
        if (!value || value.length === 0) {
            return;
        }

        value.toString().trim();
        if (!(keyCode === this.hyphenKeyCode && value.length === 6)) {
            value = value.replace(/[^0-9]/g, '');
        }
        if (value.length > 9) {
            value = value.slice(0, 9);
        }
        if (value.length > 5 && value[5] !== '-') {
            value = value.slice(0, 5) + "-" + value.slice(5);
        }

        if (value.endsWith("-")) {
            value = value.slice(0, 5);
        }

        this.el.nativeElement.value = value;
        this.ngControl.control.setValue(value);

        this.validate();
    }

    @HostListener('blur', ['$event'])
    protected onblur(event): void {
        this.validate();
    }

    private validate() {
        const value = this.el.nativeElement.value;

        if (value.length == 5 || value.length == 10) {
            this.el.nativeElement.classList.remove('invalid-zip');
        } else {
            this.el.nativeElement.classList.add('invalid-zip');
        }
    }

}