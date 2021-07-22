import { Component, OnInit, Input } from '@angular/core';
import { Category } from '../../../models/questions.model';
import { NavTreeNode } from '../../../services/navigation.service';

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

  /**
   * 
   */
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
    if (!!cat.standardShortName) {
      return cat.standardShortName.toLowerCase().replace(/ /g, '-') + '-' + cat.groupHeadingId;
    }

    return '';
  }

  /**
   * 
   */
  insertComponentSpecificOverride(tree: NavTreeNode[], q: Category) {
    // build the question group heading element
    q.subCategories.forEach(sub => {
      const heading = {
        label: sub.subCategoryHeadingText,
        value: {
          target: sub.navigationGUID,
          question: q.groupHeadingId
        },
        elementType: 'QUESTION-HEADING',
        children: []
      };
      // componentname.children.push(heading);
    });
  }
}
