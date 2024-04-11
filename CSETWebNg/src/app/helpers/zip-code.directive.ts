////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Directive, ElementRef, HostListener } from '@angular/core';
import { NgControl } from '@angular/forms';

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