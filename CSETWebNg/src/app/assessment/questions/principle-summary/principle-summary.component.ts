import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AssessmentService } from '../../../services/assessment.service';
import { CompletionService } from '../../../services/completion.service';
import { ConfigService } from '../../../services/config.service';
import { AcetFilteringService } from '../../../services/filtering/maturity-filtering/acet-filtering.service';
import { LayoutService } from '../../../services/layout.service';
import { NCUAService } from '../../../services/ncua.service';
import { QuestionsService } from '../../../services/questions.service';
import { MaturityService } from '../../../services/maturity.service';
import { HttpHeaders, HttpParams } from '@angular/common/http';
import { filter } from 'rxjs/operators';
import { ActivatedRoute, NavigationEnd, Router } from '@angular/router';
import { Subscription } from 'rxjs/internal/Subscription';
import { NavigationService } from '../../../services/navigation/navigation.service';

@Component({
  selector: 'app-principle-summary',
  templateUrl: './principle-summary.component.html',
  styleUrls: ['./principle-summary.component.scss']
})
export class PrincipleSummaryComponent implements OnInit {
  http: any;
  response: any;
  private _routerSub = Subscription.EMPTY;
  sectionId: number = 0;
  keyQuestions: string[] = ['<p><strong>How do I understand what critical functions my system must <u>ensure</u> and the undesired consequences it must <u>prevent</u>?</strong></p>'
                ,'<p><strong>How do I select and implement controls to minimize avenues for attack or the damage that could result?</strong></p>'
                ,'<p><strong>How do I prevent undesired manipulation of important data?</strong></p>'
                ,'<p><strong>How do I determine what features of my system are not absolutely necessary to achieve the critical functions?</strong></p>'
                ,'<p><strong>How do I create the best compilation of system defenses?</strong></p>'
                ,'<p><strong>How do I proactively prepare to defend my system from any threat?</strong></p>'
                ,'<p><strong>How do I understand where my system can impact others or be impacted by others?</strong></p>'
                ,'<p><strong>How do I understand where digital assets are used, what functions they are capable of, and what our assumptions are about how they work?</strong></p>'
                ,'<p><strong>How do I ensure my providers deliver the security the system needs?</strong></p>'
                ,'<p><strong>How do I turn “what ifs” into “even ifs”?</strong></p>'
                ,'<p><strong>How do I manage knowledge about my system? How do I keep it out of the wrong hands?</strong></p>'
                ,'<p><strong>How do I ensure that everyone’s behaviors and decisions align with our security goals?</strong></p>'];

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
    private navSvc: NavigationService,
    public maturitySvc: MaturityService
  ) {
    // listen for NavigationEnd to know when the page changed
    this._routerSub = this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe((e: any) => {
      if (e.urlAfterRedirects.includes('/principle-summary/')) {
        this.grabQuestions();
      }
    });
    this.assessSvc.currentTab = 'questions';
  }

  
  ngOnInit() {
    //this.grabQuestions();
  }

  ngOnDestroy(): void {
    this._routerSub.unsubscribe();
  }

  grabQuestions() {
    this.sectionId = +this.route.snapshot.params['pri'];
    const magic = this.navSvc.getMagic();
    this.response = null;

    this.maturitySvc.getGroupingQuestions(this.sectionId).subscribe((r: any) => {
      this.response = r;
    });
  }

}
