import { Component, Input, OnInit } from '@angular/core';
import { QuestionGrouping } from '../../../../../../models/questions.model';
import { HttpHeaders, HttpParams } from '@angular/common/http';
import { MatDialog } from '@angular/material/dialog';
import { Router, ActivatedRoute, NavigationEnd } from '@angular/router';
import { filter } from 'rxjs/operators';
import { AssessmentService } from '../../../../../../services/assessment.service';
import { CompletionService } from '../../../../../../services/completion.service';
import { ConfigService } from '../../../../../../services/config.service';
import { AcetFilteringService } from '../../../../../../services/filtering/maturity-filtering/acet-filtering.service';
import { LayoutService } from '../../../../../../services/layout.service';
import { MaturityService } from '../../../../../../services/maturity.service';
import { NCUAService } from '../../../../../../services/ncua.service';
import { QuestionsService } from '../../../../../../services/questions.service';
import { Subscription } from 'rxjs/internal/Subscription';

@Component({
  selector: 'app-principle-analysis-cie',
  templateUrl: './principle-analysis-cie.component.html',
  styleUrls: ['./principle-analysis-cie.component.scss']
})
export class PrincipleAnalysisCieComponent implements OnInit {
  //@Input() myGrouping: QuestionGrouping;
  private _routerSub = Subscription.EMPTY;
  sectionId: number;
  response: any;

  headers: any = {
    headers: new HttpHeaders()
      .set('Content-Type', 'application/json'),
    params: new HttpParams()
  };
  /**
   * Constructor.
   * @param configSvc
   */
  constructor(
    public configSvc: ConfigService,
    public questionsSvc: QuestionsService,
    public assessSvc: AssessmentService,
    public acetFilteringSvc: AcetFilteringService,
    public layoutSvc: LayoutService,
    public completionSvc: CompletionService,
    public ncuaSvc: NCUAService,
    public dialog: MatDialog,
    private router: Router,
    private route: ActivatedRoute,
    public maturitySvc: MaturityService
  ) {
    // listen for NavigationEnd to know when the page changed
    this._routerSub = this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe((e: any) => {
      if (e.urlAfterRedirects.includes('/principle-analysis-cie/')) {
        this.grabQuestions();
      }
    });
    this.assessSvc.currentTab = 'results';
  }

  
  ngOnInit() {
    this.grabQuestions();
  }

  grabQuestions() {
    this.sectionId = +this.route.snapshot.params['pri'];

    this.maturitySvc.getGroupingQuestions(this.sectionId).subscribe((r: any) => {
      this.response = r;
    });
  }
}
