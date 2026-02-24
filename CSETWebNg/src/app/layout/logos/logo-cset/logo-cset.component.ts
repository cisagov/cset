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
import { Component, Input, OnInit, SimpleChanges } from '@angular/core';

@Component({
  selector: 'app-logo-cset',
  templateUrl: './logo-cset.component.html',
  styleUrls: ['./logo-cset.component.scss'],
  standalone: false
})
export class LogoCsetComponent implements OnInit {

  /**
   * If "white" is provided,
   */
  @Input()
  mode: string;

  @Input()
  logoHeight = 28;

  @Input()
  includeLock: boolean = true;


  logoWidth: number;

  outlineColor: string;
  fillColor: string;
  cColor: string;

  constructor() { }

  ngOnInit(): void {
    this.logoWidth = this.logoHeight * 4.28;
    this.updateColors();

  }
  ngOnChanges(changes: SimpleChanges) {
    if (changes['mode']) {
      this.updateColors()
    }
  }

  private updateColors(): void {
    if (this.mode == 'white') {
      this.outlineColor = 'fill-white';
      this.fillColor = 'fill-white';
      this.cColor = 'cset-logo-fill-color'
    } else {
      this.outlineColor = 'cset-logo-fill-color';
      this.fillColor = 'cset-logo-fill-color';
      this.cColor = 'fill-white';
    }
  }
}
