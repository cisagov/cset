import { Component, Input, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { CisService } from '../../../services/cis.service';
import { QuestionsService } from '../../../services/questions.service';
import { Utilities } from '../../../services/utilities.service';

@Component({
  selector: 'app-option-block-nested-report',
  templateUrl: './option-block-nested-report.component.html',
  styleUrls: ['./option-block-nested-report.component.scss']
})
export class OptionBlockNestedReportComponent implements OnInit {

  @Input() q: any;
  @Input() opts: any[];

  optRadio: any[];
  optCheckbox: any[];
  optOther: any[];

  optionGroupName = '';
  sectionId = 0;

  // temporary debug aids
  showIdTag = false;
  showWeightTag = false;

  constructor(
    public questionsSvc: QuestionsService,
    public cisSvc: CisService,
    private utilSvc: Utilities,
    private route: ActivatedRoute,
  ) { }

  ngOnInit(): void {
    this.sectionId = +this.route.snapshot.params['sec'];
    // break up the options so that we can group radio buttons in a mixed bag of options
    this.optRadio = this.opts?.filter(x => x.optionType == 'radio');
    this.optCheckbox = this.opts?.filter(x => x.optionType == 'checkbox');
    this.optOther = this.opts?.filter(x => x.optionType != 'radio' && x.optionType != 'checkbox');

    // create a random 'name' that can be used to group the radios in this block
    this.optionGroupName = this.utilSvc.makeId(8);
  }

}
