////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { AssessmentComponent } from '../assessment/assessment.component';
import { ModuleContentLaunchComponent } from '../reports/module-content/module-content-launch/module-content-launch.component';
import { AssessGuard } from '../guards/assess.guard';
import { AuthGuard } from '../guards/auth.guard';
import { LoginComponent } from '../initial/login/login.component';
import { ResetPassComponent } from '../initial/reset-pass/reset-pass.component';
import { ResourceLibraryComponent } from '../resource-library/resource-library.component';
import { SetListComponent } from '../builder/custom-set-list/custom-set-list.component';
import { CustomSetComponent } from '../builder/set-detail/set-detail.component';
import { RequirementListComponent } from '../builder/requirement-list/requirement-list.component';
import { QuestionListComponent } from '../builder/question-list/question-list.component';
import { AddQuestionComponent } from '../builder/add-question/add-question.component';
import { RequirementDetailComponent } from '../builder/requirement-detail/requirement-detail.component';
import { StandardDocumentsComponent } from '../builder/standard-documents/standard-documents.component';
import { RefDocumentComponent } from '../builder/ref-document/ref-document.component';
import { AggregationHomeComponent } from '../aggregation/aggregation-home/aggregation-home.component';
import { MergeComponent } from '../aggregation/merge/merge.component';
import { AliasAssessmentsComponent } from '../aggregation/alias-assessments/alias-assessments.component';
import { AggregationGuard } from '../guards/aggregation.guard';
import { AggregationDetailComponent } from '../aggregation/aggregation-detail/aggregation-detail.component';
import { TrendAnalyticsComponent } from '../aggregation/trend-analytics/trend-analytics.component';
import { CompareAnalyticsComponent } from '../aggregation/compare-analytics/compare-analytics.component';
import { ReportTestComponent } from '../reports/report-test/report-test.component';
import { LayoutSwitcherComponent } from '../layout/layout-switcher/layout-switcher.component';
import { LayoutBlankComponent } from '../layout/layout-blank/layout-blank.component';
import { AssessmentComparisonAnalyticsComponent } from '../initial/assessmenet-comparison-analytics/assessment-comparison-analytics.component';
import { LandingPageTabsComponent } from '../initial/landing-page-tabs/landing-page-tabs.component';
import { PrivacyWarningComponent } from '../initial/privacy-warning/privacy-warning.component';
import { PrivacyWarningRejectComponent } from '../initial/privacy-warning-reject/privacy-warning-reject.component';
import { LogoutComponent } from '../initial/logout/logout.component';
import { LoginAccessKeyComponent } from '../initial/login-access-key/login-access-key.component';
import { MergeCieAnalysisComponent } from '../assessment/merge/merge-cie-analysis/merge-cie-analysis.component';


const appRoutes: Routes = [
  // reports routing
  {
    path: 'report-test',
    component: LayoutSwitcherComponent,
    children: [
      { path: '', component: ReportTestComponent }
    ]
  },
  {
    path: 'home',
    component: LayoutSwitcherComponent,
    children: [
      { path: 'privacy-warning', component: PrivacyWarningComponent },
      { path: 'privacy-warning-reject', component: PrivacyWarningRejectComponent },
      { path: 'login/assessment/:id', component: LoginComponent },
      { path: 'login/:eject', component: LoginComponent },
      { path: 'login', component: LoginComponent },
      { path: 'login-access', component: LoginAccessKeyComponent },
      { path: 'logout', component: LogoutComponent },
      { path: 'reset-pass', component: ResetPassComponent },
      {
        path: 'landing-page-tabs',
        component: LandingPageTabsComponent,
        canActivate: [AuthGuard],
        canActivateChild: [AuthGuard]
      },
      { path: '', redirectTo: 'landing-page-tabs', pathMatch: 'full' },
      { path: '**', redirectTo: 'landing-page-tabs' }
    ]
  },
  {
    path: '',
    component: LayoutSwitcherComponent,
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
      { path: 'compare-analytics/:id/:type', component: CompareAnalyticsComponent },
      { path: 'trend-analytics/:id', component: TrendAnalyticsComponent },

      { path: 'importModule', loadChildren: () => import('./import-routing.module').then(m => m.ImportRoutingModule) },

      { path: 'module-content-launch', component: ModuleContentLaunchComponent },

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
      {
        path: 'assessment-comparison-analytics',
        component: AssessmentComparisonAnalyticsComponent
      },
      {
        path: 'resource-library',
        component: ResourceLibraryComponent
      },
      {
        path: 'merge-cie-analysis',
        component: MergeCieAnalysisComponent
      },

      {
        path: 'assessment/:id',
        component: AssessmentComponent,
        canActivate: [AssessGuard],
        canActivateChild: [AssessGuard],
        children: [
          { path: '', loadChildren: () => import('./assessments-routing/assessment-routing.module').then(m => m.AssessmentRoutingModule) },
        ]
      },
      { path: '', redirectTo: '/home/landing-page-tabs', pathMatch: 'full' }
    ]
  },
  // reports routing
  {
    path: 'report', component: LayoutBlankComponent, children: [
      { path: '', loadChildren: () => import('./reports-routing/report-routing.module').then(m => m.ReportRoutingModule) },
    ]
  },
  { path: '**', redirectTo: 'home' }
];

@NgModule({
  imports: [RouterModule.forRoot(appRoutes, { enableTracing: false })],
  exports: [RouterModule]
})
export class AppRoutingModule { }
