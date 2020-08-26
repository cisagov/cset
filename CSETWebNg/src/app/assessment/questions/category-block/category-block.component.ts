import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-category-block',
  templateUrl: './category-block.component.html'
})
export class CategoryBlockComponent implements OnInit {

  @Input('myCategory') myCategory;

  /**
   * 
   */
  constructor() { }

  /**
   * 
   */
  ngOnInit() {
  }

    /**
   * Builds category IDs in a consistent way.
   */
  formatID(s) {
    return s.toLowerCase().replace(/ /g, '-');
  }
}
