import { Injectable } from '@angular/core';

/**
 * A service that can offer colors for display consistency.
 */
@Injectable({
  providedIn: 'root'
})
export class ColorService {

  colorArray = [
    '#922118',
    '#ff0000',
    '#ff3300',
    '#ff6600',
    '#ff9900',
    '#ffcc00',
    '#ffff00',
    '#ccff00',
    '#99ff00',
    '#66ff00',
    '#200029',
    '#cc2171',
    '#33ff00',
    '#00ff00',
  ];

  used = new Map<String, String>();
  usedIndex = 0;


  constructor() { }

  /**
   * Returns a color that is mapped to the provided string
   */
  getColorForAssessment(alias: string) {
    if (this.used[alias] != null) {
      return this.used[alias];
    }

    let color = this.colorArray[this.usedIndex];
    this.usedIndex++;
    return color;
  }
}
