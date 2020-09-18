import { Component, OnInit, Input } from '@angular/core';
import { Category } from '../../../models/questions.model';

@Component({
  selector: 'app-category-block',
  templateUrl: './category-block.component.html'
})
export class CategoryBlockComponent implements OnInit {

  @Input('myCategory') c: Category;

  /**
   * 
   */
  constructor() { }

  /**
   * 
   */
  ngOnInit() {
  }

  addDomainPad(domain) {
    if (domain != null) {
      return "domain-pad";
    }
    return "";
  }
  
  /**
   * 
   */
  buildNavTargetID(cat) {
    if (!!cat.StandardShortName) {
      return cat.StandardShortName.toLowerCase().replace(/ /g, '-') + '-' + cat.GroupHeadingId;
    }

    return '';
  }
}
