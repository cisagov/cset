////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
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
import { Injectable } from '@angular/core';

/**
 * A service that can offer colors for display consistency.
 */
@Injectable({
  providedIn: 'root'
})
export class ColorService {

  colorArray = [
    '#0000FF',
    '#FFD700',
    '#008000',
    '#6495ED',
    '#006400',
    '#F0E68C',
    '#00008B',
    '#008B8B',
    '#FFFACD',
    '#483D8B',
    '#2F4F4F',
    '#9400D3',
    '#1E90FF',
    '#B22222',
    '#FFFAF0',
    '#228B22',
    '#DAA520',
    '#ADFF2F',
    '#4B0082',
    '#000080'
  ];

  used: Map<String, String>;
  usedIndex = 0;


  constructor() {
    this.reset();
  }

  /**
   * Clears the color mapping
   */
  reset() {
    this.used = new Map<String, String>();
    this.usedIndex = 0;
  }

  /**
   * Returns a color that is mapped to the provided string.
   * When the color array is exhausted it cycles back to the
   * beginning for new color assignments.
   */
  getColorForAssessment(alias: string) {
    if (!!this.used[alias]) {
      return this.used[alias];
    }

    let color = this.colorArray[this.usedIndex];
    this.used[alias] = color;
    this.usedIndex++;
    if (this.usedIndex >= this.colorArray.length) {
      this.usedIndex = 0;
    }
    return color;
  }

  /**
   * Returns a standard HTML color string for the 
   * specified function.  This will promote consistency
   * anywhere CSF colors are displayed in CSET.
   */
  nistCsfFuncColor(func: string) {
    switch (func) {
      case 'ID':
        return '#355C9B';
      case 'PR':
        return '#784390';
      case 'DE':
        return '#F7E24E';
      case 'RS':
        return '#D93A34';
      case 'RC':
        return '#4CA056';
      default:
        return '#FFFFFF';
    }
  }
}
