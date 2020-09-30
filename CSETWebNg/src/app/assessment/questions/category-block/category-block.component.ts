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
    this.c.Visible = true;    // maybe this needs to be smarter
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
    if (!!cat.StandardShortName) {
      return cat.StandardShortName.toLowerCase().replace(/ /g, '-') + '-' + cat.GroupHeadingId;
    }

    return '';
  }

  /**
   * 
   */
  insertComponentSpecificOverride(tree: NavTreeNode[], q: Category) {
    // build the question group heading element
    q.SubCategories.forEach(sub => {
      const heading = {
        label: sub.SubCategoryHeadingText,
        value: {
          target: sub.NavigationGUID,
          question: q.GroupHeadingId
        },
        elementType: 'QUESTION-HEADING',
        children: []
      };
      // componentname.children.push(heading);
    });
  }
}
