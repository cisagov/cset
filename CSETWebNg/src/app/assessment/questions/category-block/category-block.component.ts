import { Component, OnInit, Input } from '@angular/core';
import { QuestionGroup } from '../../../models/questions.model';

@Component({
  selector: 'app-category-block',
  templateUrl: './category-block.component.html'
})
export class CategoryBlockComponent implements OnInit {

  @Input('myCategory') c: QuestionGroup;

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
   * Builds category IDs in a consistent way.
   */
  formatID(s) {
    return s.toLowerCase().replace(/ /g, '-');
  }
}
