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

  used : Map<String, String>;
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
}
