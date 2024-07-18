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

  /**
   * Returns a hex color code of black or white,
   * depending on the specified background color.
   */
  textColor(bgColor) {
    bgColor = this.normalizeHexColor(bgColor);

    bgColor = bgColor.replace('#', '');

    let r = parseInt(bgColor.substring(0, 2), 16);
    let g = parseInt(bgColor.substring(2, 4), 16);
    let b = parseInt(bgColor.substring(4, 6), 16);

    // Calculate the luminance
    let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b;

    // Return white for dark backgrounds and black for light backgrounds
    return luminance < 140 ? '#ffffff' : '#000000';
  }

  /**
   * Normalizes shorter hex color codes to 6 or 8 characters.
   */
  normalizeHexColor(hex) {
    hex = hex.replace('#', '');

    // Expand shorthand form (3 digits) to full form (6 digits)
    if (hex.length === 3) {
      hex = hex.split('').map(char => char + char).join('');
    }

    // Expand shorthand form with alpha (4 digits) to full form (8 digits)
    if (hex.length === 4) {
      hex = hex.split('').map(char => char + char).join('');
    }

    // If the color has 6 or 8 digits, it's already in full form
    if (hex.length === 6 || hex.length === 8) {
      return `#${hex}`;
    }

    throw new Error('Invalid hex color format');
  }
}
