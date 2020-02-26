////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { AssessmentComponent } from './assessment/assessment.component';
import { AssessmentInfoComponent } from './assessment/prepare/assessment-info/assessment-info.component';
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
import { DetailComponent } from './reports/detail/detail.component';
import { DiscoveryTearoutsComponent } from './reports/discovery-tearouts/discovery-tearouts.component';
import { ExecutiveComponent } from './reports/executive/executive.component';
import { SecurityplanComponent } from './reports/securityplan/securityplan.component';

const appRoutes: Routes = [


  // reports routing
  {
    path: 'report-test', component: LayoutBlankComponent, children: [
      { path: '', component: ReportTestComponent }
    ]
  },


  {
    path: 'home',
    component: LayoutMainComponent,
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
    component: LayoutMainComponent,
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
              { path: 'info', component: AssessmentInfoComponent },
              { path: 'sal', component: SalsComponent },
              { path: 'standards', component: StandardsComponent },
              { path: 'framework', component: FrameworkComponent },
              { path: 'required', component: RequiredDocsComponent },
              { path: 'irp', component: IRPComponent },
              { path: 'irp-summary', component: IrpSummaryComponent },
              { path: '', redirectTo: 'info', pathMatch: 'full' },
              { path: '**', redirectTo: 'info' }
            ]
          },
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

          { path: 'questions', component: QuestionsComponent },
          {
            path: 'results',
            component: ResultsComponent,
            canActivate: [AssessGuard],
            canActivateChild: [AssessGuard],
            children: [
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

              { path: 'maturity', component: MatDetailComponent },
              { path: 'admin', component: AdminComponent },
              { path: 'acetDashboard', component: ACETDashboardComponent },
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
  { path: '**', redirectTo: 'home' }
];

@NgModule({
  imports: [RouterModule.forRoot(appRoutes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
