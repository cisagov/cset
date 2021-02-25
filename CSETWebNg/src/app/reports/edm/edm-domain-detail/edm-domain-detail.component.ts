import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { MaturityService } from '../../../services/maturity.service';
import { ConfigService } from '../../../services/config.service';

@Component({
  selector: 'app-edm-domain-detail',
  templateUrl: './edm-domain-detail.component.html',
  styleUrls: ['../../reports.scss']
})
export class EdmDomainDetailComponent implements OnInit {


  @Input()
  domain: any;


  /**
   * 
   * @param configSvc 
   * @param maturitySvc 
   */
  constructor(
    public configSvc: ConfigService,
    public maturitySvc: MaturityService
  ) { }


  ngOnInit() { }

  /**
   * Sets the coloring of a cell based on its answer.
   * @param answer 
   */
  answerCellClass(answer: string) {
    switch (answer) {
      case 'Y':
        return 'green-score';
      case 'I':
        return 'yellow-score';
      case 'N':
        return 'red-score';
      case 'U':
        return 'default-score';
    }
  }

  /**
   * Looks up the Options For Consideration from the collection held by
   * the MaturityService.  
   * @param questionId 
   */
  getOfc(questionId: number) {
    if (!this.maturitySvc.ofc) {
      return '';
    }

    const questionOption = this.maturitySvc.ofc.find(x => x.Mat_Question_Id == questionId);
    return questionOption.Reference_Text;
  }

}
