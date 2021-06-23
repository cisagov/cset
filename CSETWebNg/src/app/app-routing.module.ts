////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ConfigService } from './services/config.service';
import { AssessmentComponent } from './assessment/assessment.component';
import { AssessmentInfoComponent } from './assessment/prepare/assessment-info/assessment-info.component';
import { Assessment2InfoComponent } from './assessment/prepare/assessment-info/assessment2-info/assessment2-info.component';
import { FrameworkComponent } from './assessment/prepare/framework/framework.component';
import { RequiredDocsComponent } from './assessment/prepare/required/required.component';
import { IRPComponent } from './assessment/prepare/irp/irp.component';
import { PrepareComponent } from './assessment/prepare/prepare.component';
import { SalsComponent } from './assessment/prepare/sals/sals.component';
import { StandardsComponent } from './assessment/prepare/standards/standards.component';
import { QuestionsComponent } from './assessment/questions/questions.component';
import { AnalysisComponent } from './assessment/results/analysis/analysis.component';
import { ComponentsRankedComponent } from './assessment/results/analysis/components-ranked/components-ranked.component';
import { ComponentsResultsComponent } from './assessment/results/analysis/components-results/components-results.component';
import { ComponentsSummaryComponent } from './assessment/results/analysis/components-summary/components-summary.component';
import { ComponentsTypesComponent } from './assessment/results/analysis/components-types/components-types.component';
import { ComponentsWarningsComponent } from './assessment/results/analysis/components-warnings/components-warnings.component';
import { DashboardComponent } from './assessment/results/analysis/dashboard/dashboard.component';
// tslint:disable-next-line:max-line-length
import { FeedbackComponent } from './assessment/results/feedback/feedback.component';
import { RankedQuestionsComponent } from './assessment/results/analysis/ranked-questions/ranked-questions.component';
import { StandardsRankedComponent } from './assessment/results/analysis/standards-ranked/standards-ranked.component';
import { StandardsResultsComponent } from './assessment/results/analysis/standards-results/standards-results.component';
import { StandardsSummaryComponent } from './assessment/results/analysis/standards-summary/standards-summary.component';
import { OverviewComponent } from './assessment/results/overview/overview.component';
import { ReportsComponent } from './assessment/results/reports/reports.component';
import { ResultsComponent } from './assessment/results/results.component';
import { AssessGuard } from './guards/assess.guard';
import { AuthGuard } from './guards/auth.guard';
import { InitialComponent } from './initial/initial.component';
import { LandingPageComponent } from './initial/landing-page/landing-page.component';
import { LoginComponent } from './initial/login/login.component';
import { ResetPassComponent } from './initial/reset-pass/reset-pass.component';
import { ResourceLibraryComponent } from './resource-library/resource-library.component';
import { ImportComponent } from './import/import.component';
import { MatDetailComponent } from './assessment/results/mat-detail/mat-detail.component';
import { ACETDashboardComponent } from './assessment/results/dashboard/acet-dashboard.component';
import { AdminComponent } from './assessment/results/admin/admin.component';
import { SetListComponent } from './builder/custom-set-list/custom-set-list.component';
import { CustomSetComponent } from './builder/set-detail/set-detail.component';
import { RequirementListComponent } from './builder/requirement-list/requirement-list.component';
import { QuestionListComponent } from './builder/question-list/question-list.component';
import { AddQuestionComponent } from './builder/add-question/add-question.component';
import { RequirementDetailComponent } from './builder/requirement-detail/requirement-detail.component';
import { StandardDocumentsComponent } from './builder/standard-documents/standard-documents.component';
import { RefDocumentComponent } from './builder/ref-document/ref-document.component';
import { IrpSummaryComponent } from './assessment/prepare/irp-summary/irp-summary.component';
import { DiagramComponent } from './assessment/diagram/diagram.component';
import { DiagramInfoComponent } from './assessment/diagram/diagram-info/diagram-info.component';
import { DiagramInventoryComponent } from './assessment/diagram/diagram-inventory/diagram-inventory.component';
import { AggregationHomeComponent } from './aggregation/aggregation-home/aggregation-home.component';
import { MergeComponent } from './aggregation/merge/merge.component';
import { AliasAssessmentsComponent } from './aggregation/alias-assessments/alias-assessments.component';
import { AggregationGuard } from './guards/aggregation.guard';
import { AggregationDetailComponent } from './aggregation/aggregation-detail/aggregation-detail.component';
import { TrendAnalyticsComponent } from './aggregation/trend-analytics/trend-analytics.component';
import { CompareAnalyticsComponent } from './aggregation/compare-analytics/compare-analytics.component';
import { AnalyticsComponent } from './assessment/results/analytics/analytics.component';
import { LayoutBlankComponent } from './layout/layoutblank/layout-blank.component';
import { ReportTestComponent } from './reports/report-test/report-test.component';
import { LayoutMainComponent } from './layout/layoutmain/layout-main.component';
import { AcetLayoutMainComponent } from './layout/acetlayoutmain/acet-layout-main.component';
import { DetailComponent } from './reports/detail/detail.component';
import { DiscoveryTearoutsComponent } from './reports/discovery-tearouts/discovery-tearouts.component';
import { ExecutiveComponent } from './reports/executive/executive.component';
import { ExecutiveCMMCComponent } from './reports/cmmc/executive-cmmc/executive-cmmc.component';
import { SitesummaryCMMCComponent } from './reports/cmmc/sitesummary-cmmc/sitesummary-cmmc.component';
import { SecurityplanComponent } from './reports/securityplan/securityplan.component';
import { TrendReportComponent } from './reports/trendreport/trendreport.component';
import { CompareReportComponent } from './reports/comparereport/comparereport.component';
import { SitesummaryComponent } from './reports/sitesummary/sitesummary.component';
import { ModelSelectComponent } from './assessment/prepare/maturity/model-select/model-select.component';
import { CmmcLevelsComponent } from './assessment/prepare/maturity/cmmc-levels/cmmc-levels.component';
import { MaturityQuestionsComponent } from './assessment/questions/maturity-questions/maturity-questions.component';
import { MaturityQuestionsAcetComponent } from './assessment/questions/maturity-questions/maturity-questions-acet.component';
import { DiagramQuestionsComponent } from './assessment/questions/diagram-questions/diagram-questions.component';
import { CmmcLevelResultsComponent } from './assessment/results/mat-cmmc/cmmc-level-results/cmmc-level-results.component';
import { CmmcGapsComponent } from './assessment/results/mat-cmmc/cmmc-gaps/cmmc-gaps.component';
import { CmmcComplianceComponent } from './assessment/results/mat-cmmc/cmmc-compliance/cmmc-compliance.component';
import { CmmcLevelDrilldownComponent } from './assessment/results/mat-cmmc/cmmc-level-drilldown/cmmc-level-drilldown.component';



import { TutorialCmmcComponent } from './assessment/prepare/maturity/tutorial-cmmc/tutorial-cmmc.component';
import { TutorialEdmComponent } from './assessment/prepare/maturity/tutorial-edm/tutorial-edm.component';



import { AcetExecutiveComponent } from './reports/acet-executive/acet-executive.component';
import { AcetDeficencyComponent } from './reports/acet-deficency/acet-deficency.component';
import { AcetCommentsmarkedComponent} from './reports/acet-commentsmarked/acet-commentsmarked.component';
import { AcetCompensatingcontrolsComponent} from './reports/acet-compensatingcontrols/acet-compensatingcontrols.component';
import { AcetAnsweredQuestionsComponent} from './reports/acet-answeredquestions/acet-answeredquestions.component';
import { EdmComponent } from './reports/edm/edm.component';
import { EdmDeficiencyComponent } from './reports/edm-deficiency/edm-deficiency.component';
import { EdmCommentsmarkedComponent } from './reports/edm-commentsmarked/edm-commentsmarked.component';
import { PlaceholderQuestionsComponent } from './assessment/questions/placeholder-questions/placeholder-questions.component';
import { RelationshipFormationComponent } from './assessment/results/edm/relationship-formation/relationship-formation.component';
import { RelationshipManagementComponent } from './assessment/results/edm/relationship-management/relationship-management.component';
import { ServiceProtectionComponent } from './assessment/results/edm/service-protection/service-protection.component';
import { MaturityIndicatorLevelsComponent } from './assessment/results/edm/maturity-indicator-levels/maturity-indicator-levels.component';
import { EdmSummaryResultsComponent } from './reports/edm/edm-summary-results/edm-summary-results.component';
import { SummaryResultsComponent } from './assessment/results/edm/summary-results/summary-results.component';
import { CmmcDeficiencyComponent } from './reports/cmmc/cmmc-deficiency/cmmc-deficiency.component';
import { CmmcCommentsMarkedComponent } from './reports/cmmc/cmmc-comments-marked/cmmc-comments-marked.component';
import { CmmcAltJustificationsComponent } from './reports/cmmc/cmmc-alt-justifications/cmmc-alt-justifications.component';
import { TutorialCrrComponent } from './assessment/prepare/maturity/tutorial-crr/tutorial-crr.component';
import { CrrExecutiveComponent } from './reports/crr/crr-executive/crr-executive.component';
import { CrrDeficiencyComponent } from './reports/crr/crr-deficiency/crr-deficiency.component';
import { CrrCommentsMarkedComponent } from './reports/crr/crr-comments-marked/crr-comments-marked.component';


import { RraReportComponent } from './reports/rra/rra-executive/rra-report.component';
import { RraDeficiencyComponent } from './reports/rra/rra-deficiency/rra-deficiency.component';
import { TutorialRraComponent } from './assessment/prepare/maturity/tutorial-rra/tutorial-rra.component';
import { RraGapsComponent } from './assessment/results/mat-rra/rra-gaps/rra-gaps.component';
import { RraLevelResultsComponent } from './assessment/results/mat-rra/rra-level-results/rra-level-results.component';
import { CommentsMfrComponent } from './reports/commentsmfr/commentsmfr.component';
import { RraSummaryComponent } from './assessment/results/mat-rra/rra-summary/rra-summary.component';
import { RraSummaryAllComponent } from './assessment/results/mat-rra/rra-summary-all/rra-summary-all.component';

const isAcetApp = localStorage.getItem('isAcetApp') == 'true' ? true : false;
const appRoutes: Routes = [

  // reports routing
  {
    path: 'report-test', component: LayoutBlankComponent, children: [
      { path: '', component: ReportTestComponent }
    ]
  },
  {
    path: 'home',
    component: isAcetApp ? AcetLayoutMainComponent : LayoutMainComponent,
    children: [
      { path: 'login/assessment/:id', component: LoginComponent },
      { path: 'login/:eject', component: LoginComponent },
      { path: 'login', component: LoginComponent },
      { path: 'reset-pass', component: ResetPassComponent },
      {
        path: 'landing-page',
        component: LandingPageComponent,
        canActivate: [AuthGuard],
        canActivateChild: [AuthGuard]
      },
      { path: '', redirectTo: 'landing-page', pathMatch: 'full' },
      { path: '**', redirectTo: 'landing-page' }
    ]
  },
  {
    path: '',
    component: isAcetApp ? AcetLayoutMainComponent : LayoutMainComponent,
    children: [
      { path: 'compare', component: AggregationHomeComponent },
      { path: 'merge', component: MergeComponent },
      {
        path: 'trend',
        component: AggregationHomeComponent,
        children: [
          {
            path: 'alias-assessments/:id',
            component: AliasAssessmentsComponent,
            canActivate: [AggregationGuard]
          },
          { path: '', redirectTo: 'trend', pathMatch: 'full' },
          { path: '**', redirectTo: 'trend' }
        ]
      },
      { path: 'alias-assessments/:id', component: AliasAssessmentsComponent },
      { path: 'aggregation-detail/:id', component: AggregationDetailComponent },
      { path: 'compare-analytics/:id', component: CompareAnalyticsComponent },
      { path: 'trend-analytics/:id', component: TrendAnalyticsComponent },

      { path: 'importModule', component: ImportComponent },

      { path: 'set-list', component: SetListComponent },
      {
        path: 'set-detail/:id',
        component: CustomSetComponent
      },
      {
        path: 'standard-documents/:id',
        component: StandardDocumentsComponent
      },
      {
        path: 'ref-document/:id',
        component: RefDocumentComponent
      },
      {
        path: 'requirement-list/:id',
        component: RequirementListComponent
      },
      {
        path: 'requirement-detail/:id',
        component: RequirementDetailComponent
      },
      {
        path: 'question-list/:id',
        component: QuestionListComponent
      },
      {
        path: 'add-question/:id',
        component: AddQuestionComponent
      },

      { path: 'resource-library', component: ResourceLibraryComponent },

      {
        path: 'assessment/:id',
        component: AssessmentComponent,
        canActivate: [AssessGuard],
        canActivateChild: [AssessGuard],
        children: [
          {
            path: 'prepare',
            component: PrepareComponent,
            canActivate: [AssessGuard],
            canActivateChild: [AssessGuard],
            children: [
              { path: 'info1', component: AssessmentInfoComponent },
              { path: 'info2', component: Assessment2InfoComponent },
              { path: 'model-select', component: ModelSelectComponent },
              { path: 'tutorial-cmmc', component: TutorialCmmcComponent },
              { path: 'tutorial-edm', component: TutorialEdmComponent },
              { path: 'tutorial-crr', component: TutorialCrrComponent },
              { path: 'tutorial-rra', component: TutorialRraComponent },
              { path: 'cmmc-levels', component: CmmcLevelsComponent },
              { path: 'sal', component: SalsComponent },
              { path: 'standards', component: StandardsComponent },
              { path: 'framework', component: FrameworkComponent },
              { path: 'required', component: RequiredDocsComponent },
              { path: 'irp', component: IRPComponent },
              { path: 'irp-summary', component: IrpSummaryComponent },
              {
                path: 'diagram',
                component: DiagramComponent,
                canActivate: [AssessGuard],
                canActivateChild: [AssessGuard],
                children: [
                  { path: 'info', component: DiagramInfoComponent },
                  { path: 'inventory', component: DiagramInventoryComponent },
                  { path: '', redirectTo: 'info', pathMatch: 'full' },
                  { path: '**', redirectTo: 'info' }
                ]
              },
              { path: '', redirectTo: 'info1', pathMatch: 'full' },
              { path: '**', redirectTo: 'info1' }
            ]
          },          

          { path: 'questions', component: QuestionsComponent },
          { path: 'placeholder-questions', component: PlaceholderQuestionsComponent },
          { path: 'maturity-questions', component: MaturityQuestionsComponent },
          { path: 'maturity-questions-acet', component: MaturityQuestionsAcetComponent },
          { path: 'diagram-questions', component: DiagramQuestionsComponent },
          {
            path: 'results',
            component: ResultsComponent,
            canActivate: [AssessGuard],
            canActivateChild: [AssessGuard],
            children: [
              { path: 'cmmc-level-results', component: CmmcLevelResultsComponent },
              { path: 'cmmc-level-drilldown', component: CmmcLevelDrilldownComponent },
              { path: 'cmmc-compliance', component: CmmcComplianceComponent },
              { path: 'cmmc-gaps', component: CmmcGapsComponent },
              { path: 'rra-summary-all', component: RraSummaryAllComponent },
              { path: 'rra-level-results', component: RraLevelResultsComponent },
              { path: 'rra-gaps', component: RraGapsComponent },
              { path: 'analysis', component: AnalysisComponent },
              { path: 'dashboard', component: DashboardComponent },
              { path: 'ranked-questions', component: RankedQuestionsComponent },
              { path: 'feedback', component: FeedbackComponent },
              // { path: 'overall-ranked-categories', component: OverallRankedCategoriesComponent },
              { path: 'standards-summary', component: StandardsSummaryComponent },
              { path: 'standards-ranked', component: StandardsRankedComponent },
              { path: 'standards-results', component: StandardsResultsComponent },
              { path: 'components-summary', component: ComponentsSummaryComponent },
              { path: 'components-ranked', component: ComponentsRankedComponent },
              { path: 'components-results', component: ComponentsResultsComponent },
              { path: 'components-types', component: ComponentsTypesComponent },
              { path: 'components-warnings', component: ComponentsWarningsComponent },

              { path: 'summary-results', component: SummaryResultsComponent }, 
              { path: 'relationship-formation', component: RelationshipFormationComponent },
              { path: 'relationship-management', component: RelationshipManagementComponent },
              { path: 'service-protection', component: ServiceProtectionComponent },
              { path: 'maturity-indicator-levels', component: MaturityIndicatorLevelsComponent },

              { path: 'acet-maturity', component: MatDetailComponent },
              { path: 'acet-dashboard', component: ACETDashboardComponent },
            
              { path: 'overview', component: OverviewComponent },
              { path: 'reports', component: ReportsComponent },
              { path: 'feedback', component: FeedbackComponent },
              { path: 'analytics', component: AnalyticsComponent },
              { path: '', component: DashboardComponent },
            ]
          },

          { path: '', redirectTo: 'prepare', pathMatch: 'full' },
          { path: '**', redirectTo: 'prepare' }
        ]
      },
      { path: '', redirectTo: '/home/landing-page', pathMatch: 'full' }
    ]
  },
  // reports routing
  {
    path: 'report', component: LayoutBlankComponent, children: [
      { path: 'detail', component: DetailComponent },
      { path: 'discoveries', component: DiscoveryTearoutsComponent },
      { path: 'executive', component: ExecutiveComponent },
      { path: 'securityplan', component: SecurityplanComponent },
      { path: 'sitesummary', component: SitesummaryComponent },
      { path: 'trendreport', component: TrendReportComponent },
      { path: 'comparereport', component: CompareReportComponent },
      { path: 'executivecmmc', component: ExecutiveCMMCComponent },
      { path: 'sitesummarycmmc', component: SitesummaryCMMCComponent },
      { path: 'cmmcDeficiencyReport', component: CmmcDeficiencyComponent },
      { path: 'cmmcCommentsMarked', component: CmmcCommentsMarkedComponent },
      { path: 'cmmcAltJustifications', component: CmmcAltJustificationsComponent },
      { path: 'edm', component: EdmComponent},
      { path: 'edmDeficiencyReport', component: EdmDeficiencyComponent }, 
      { path: 'edmCommentsmarked', component: EdmCommentsmarkedComponent },
      { path: 'acetexecutive', component: AcetExecutiveComponent },
      { path: 'acetdeficency', component: AcetDeficencyComponent },
      { path: 'acetcommentsmarked', component: AcetCommentsmarkedComponent },
      { path: 'acetansweredquestions', component: AcetAnsweredQuestionsComponent },
      { path: 'acetcompensatingcontrols', component: AcetCompensatingcontrolsComponent },
      { path: 'crrExecutive', component: CrrExecutiveComponent },
      { path: 'crrDeficiencyReport', component: CrrDeficiencyComponent },
      { path: 'crrCommentsMarked', component: CrrCommentsMarkedComponent },
      { path: 'rrareport', component: RraReportComponent },
      { path: 'rraDeficiencyReport', component: RraDeficiencyComponent },
      { path: 'commentsmfr', component: CommentsMfrComponent },
    ]
  },
  { path: '**', redirectTo: 'home' }
];

@NgModule({
  imports: [RouterModule.forRoot(appRoutes,{ enableTracing: false, relativeLinkResolution: 'legacy' })],
  exports: [RouterModule]
})
export class AppRoutingModule {}
