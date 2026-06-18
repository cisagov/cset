////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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

import { AfterViewInit, Directive, ElementRef, OnDestroy } from '@angular/core';

@Directive({
     selector: '.white-panel, .white-panel-body',
     standalone: false
})
export class WhitePanelDirective implements AfterViewInit, OnDestroy {
     private readonly observer = new ResizeObserver(() => this.setHeight());

     constructor(private readonly el: ElementRef) { }

     ngAfterViewInit() {
          this.setHeight();
          this.observer.observe(document.body);
     }

     private setHeight() {
          setTimeout(() => {
               const el = this.el.nativeElement;

               el.style.minHeight = '0';
               el.style.maxHeight = '0';

               const nav = document.querySelector('app-nav-back-next');
               if (!nav) return;
               const navRect = nav.getBoundingClientRect();

               const panelTop = el.getBoundingClientRect().top;

               const style = globalThis.getComputedStyle(el);
               const marginBottom = Number.parseFloat(style.marginBottom);

               const fudge = 35;
               const availableHeight = window.innerHeight - panelTop - navRect.height - marginBottom - fudge;

               el.style.setProperty('--panel-height', `${availableHeight}px`);

               el.style.minHeight = '';
               el.style.maxHeight = '';
          }, 0);
     }

     ngOnDestroy() {
          this.observer.disconnect();
     }
}