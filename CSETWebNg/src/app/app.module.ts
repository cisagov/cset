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
import { HTTP_INTERCEPTORS, provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';
import { DatePipe } from '@angular/common';
import { CUSTOM_ELEMENTS_SCHEMA, NgModule, inject, provideAppInitializer } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

// import { MatAutocompleteModule } from '@angular/material/autocomplete';
// import { MatNativeDateModule } from '@angular/material/core';
// import { MatDialogModule } from '@angular/material/dialog';
// import { MatDividerModule } from '@angular/material/divider';
// import { MatIconModule } from '@angular/material/icon';
// import { MatInputModule } from '@angular/material/input';
// import { MatListModule } from '@angular/material/list';
// import { MatMenuModule } from '@angular/material/menu';
// import { MatProgressBarModule } from '@angular/material/progress-bar';
// import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
// import { MatSidenavModule } from '@angular/material/sidenav';
// import { MatSnackBarModule } from '@angular/material/snack-bar';
// import { MatTabsModule } from '@angular/material/tabs';
// import { MatCardModule } from '@angular/material/card';
// import { MatTooltipModule } from '@angular/material/tooltip';
// import { MatTreeModule } from '@angular/material/tree';
// import { MatDatepickerModule } from '@angular/material/datepicker';
// import { MatFormFieldModule } from '@angular/material/form-field';
// import { MatSortModule } from '@angular/material/sort';
// import { MatExpansionModule } from '@angular/material/expansion';
// import { MatSliderModule } from '@angular/material/slider';

import { A11yModule } from '@angular/cdk/a11y';
import { CdkAccordionModule } from '@angular/cdk/accordion';
import { ClipboardModule } from '@angular/cdk/clipboard';
import { DragDropModule } from '@angular/cdk/drag-drop';
import { PortalModule } from '@angular/cdk/portal';
import { ScrollingModule } from '@angular/cdk/scrolling';
import { CdkStepperModule } from '@angular/cdk/stepper';
import { CdkTableModule } from '@angular/cdk/table';
import { CdkTreeModule } from '@angular/cdk/tree';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatBadgeModule } from '@angular/material/badge';
import { MatBottomSheetModule } from '@angular/material/bottom-sheet';
import { MatButtonModule } from '@angular/material/button';
import { MatButtonToggleModule } from '@angular/material/button-toggle';
import { MatCardModule } from '@angular/material/card';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatChipsModule } from '@angular/material/chips';
import { MatStepperModule } from '@angular/material/stepper';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatDialogModule } from '@angular/material/dialog';
import { MatDividerModule } from '@angular/material/divider';
import { MatExpansionModule } from '@angular/material/expansion';
import { MatGridListModule } from '@angular/material/grid-list';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatListModule } from '@angular/material/list';
import { MatMenuModule } from '@angular/material/menu';
import {
    MAT_DATE_LOCALE,
    MatNativeDateModule,
    MatRippleModule
} from '@angular/material/core';
import { MatPaginatorModule } from '@angular/material/paginator';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatRadioModule } from '@angular/material/radio';
import { MatSelectModule } from '@angular/material/select';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatSliderModule } from '@angular/material/slider';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { MatSortModule } from '@angular/material/sort';
import { MatTableModule } from '@angular/material/table';
import { MatTabsModule } from '@angular/material/tabs';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatTreeModule } from '@angular/material/tree';
import { OverlayModule } from '@angular/cdk/overlay';

import { NgxSliderModule } from '@angular-slider/ngx-slider';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HotkeyModule } from 'angular2-hotkeys';
import { FileUploadModule } from './modules/ng2-file-upload';
import { AppRoutingModule } from './routing/app-routing.module';
import { AppComponent } from './app.component';
import { AssessmentComponent } from './assessment/assessment.component';
import { StatusCreateComponent } from './assessment/documents/status-create/status-create.component';
import { AssessmentContactsComponent } from './assessment/prepare/assessment-info/assessment-contacts/assessment-contacts.component';
import { ContactItemComponent } from './assessment/prepare/assessment-info/assessment-contacts/contact-item/contact-item.component';
// eslint-disable-next-line max-len
import { AssessmentDemographicsComponent } from './assessment/prepare/assessment-info/assessment-demographics/assessment-demographics.component';
import { AssessmentDetailComponent } from './assessment/prepare/assessment-info/assessment-detail/assessment-detail.component';
import { AssessmentInfoComponent } from './assessment/prepare/assessment-info/assessment-info.component';
import { Assessment2InfoComponent } from './assessment/prepare/assessment-info/assessment2-info/assessment2-info.component';
import { AssessmentConfigComponent } from './assessment/prepare/assessment-info/assessment-config/assessment-config.component';
import { FrameworkComponent } from './assessment/prepare/framework/framework.component';
import { RequiredDocsComponent } from './assessment/prepare/required/required.component';
import { PrepareComponent } from './assessment/prepare/prepare.component';
import { SalGenComponent } from './assessment/prepare/sals/sal-gen/sal-gen.component';
import { SalNistComponent } from './assessment/prepare/sals/sal-nist/sal-nist.component';
import { SalSimpleComponent } from './assessment/prepare/sals/sal-simple/sal-simple.component';
import { SalsComponent } from './assessment/prepare/sals/sals.component';
import { ObservationsComponent } from './assessment/questions/observations/observations.component';
import { QuestionBlockComponent } from './assessment/questions/question-block/question-block.component';
import { QuestionExtrasComponent } from './assessment/questions/question-extras/question-extras.component';
import { QuestionsComponent } from './assessment/questions/questions.component';
import { AnalysisComponent } from './assessment/results/analysis/analysis.component';
import { ComponentsRankedComponent } from './assessment/results/analysis/components-ranked/components-ranked.component';
import { ComponentsResultsComponent } from './assessment/results/analysis/components-results/components-results.component';
import { ComponentsSummaryComponent } from './assessment/results/analysis/components-summary/components-summary.component';
import { ComponentsTypesComponent } from './assessment/results/analysis/components-types/components-types.component';
import { ComponentsWarningsComponent } from './assessment/results/analysis/components-warnings/components-warnings.component';
import { DashboardComponent } from './assessment/results/analysis/dashboard/dashboard.component';
import { RankedQuestionsComponent } from './assessment/results/analysis/ranked-questions/ranked-questions.component';
import { StandardsRankedComponent } from './assessment/results/analysis/standards-ranked/standards-ranked.component';
import { StandardsResultsComponent } from './assessment/results/analysis/standards-results/standards-results.component';
import { StandardsSummaryComponent } from './assessment/results/analysis/standards-summary/standards-summary.component';
import { OverviewComponent } from './assessment/results/overview/overview.component';
import { FeedbackComponent } from './assessment/results/feedback/feedback.component';
import { ReportsComponent } from './assessment/results/reports/reports.component';
import { ResultsComponent } from './assessment/results/results.component';
import { AboutComponent } from './dialogs/about/about.component';
import { ComponentOverrideComponent } from './dialogs/component-override/component-override.component';
import { AdvisoryComponent } from './dialogs/advisory/advisory.component';
import { AlertComponent } from './dialogs/alert/alert.component';
import { AssessmentDocumentsComponent } from './dialogs/assessment-documents/assessment-documents.component';
import { ChangePasswordComponent } from './dialogs/change-password/change-password.component';
import { ConfirmComponent } from './dialogs/confirm/confirm.component';
import { EditUserComponent } from './dialogs/edit-user/edit-user.component';
import { EjectionComponent } from './dialogs/ejection/ejection.component';
import { EmailComponent } from './dialogs/email/email.component';
import { EnableProtectedComponent } from './dialogs/enable-protected/enable-protected.component';
import { GlobalParametersComponent } from './dialogs/global-parameters/global-parameters.component';
import { InlineParameterComponent } from './dialogs/inline-parameter/inline-parameter.component';
import { KeyboardShortcutsComponent } from './dialogs/keyboard-shortcuts/keyboard-shortcuts.component';
import { LicenseComponent } from './dialogs/license/license.component';
import { OkayComponent } from './dialogs/okay/okay.component';
import { QuestionFiltersComponent } from './dialogs/question-filters/question-filters.component';
import { QuestionFiltersReportsComponent } from './dialogs/question-filters-reports/question-filters-reports.component';
import { TermsOfUseComponent } from './dialogs/terms-of-use/terms-of-use.component';
import { AccessibilityStatementComponent } from './dialogs/accessibility-statement/accessibility-statement.component';
import { UploadExportComponent } from './dialogs/upload-export/upload-export.component';
import { AssessGuard } from './guards/assess.guard';
import { AuthGuard } from './guards/auth.guard';
import { AggregationGuard } from './guards/aggregation.guard';
import { ConfirmEqualValidatorDirective } from './helpers/confirm-equal-validator.directive';
import { EmailValidatorDirective } from './helpers/email-validator.directive';
import { FocusDirective } from './helpers/focus.directive';
import { AutoSizeDirective } from './helpers/auto-size.directive';
import { DigitsOnlyDirective } from './helpers/digits-only.directive';
import { InViewComponent } from './helpers/in-view/in-view.component';
import { JwtInterceptor } from './helpers/jwt.interceptor';
import { ProgressComponent } from './helpers/progress/progress.component';
import { SafePipe } from './helpers/safe.pipe';
import { LinebreakPipe } from './helpers/linebreak.pipe';
import { LinebreakPlaintextPipe } from './helpers/linebreakplain.pipe';
import { NullishCoalescePipe } from './helpers/nullish-coalesce.pipe';
import { CompletionCountPipe } from './helpers/completion-count.pipe';
import { LocalizeDatePipe } from './helpers/date-localize.pipe';
import { InitialComponent } from './initial/initial.component';
import { MyAssessmentsComponent } from './initial/my-assessments/my-assessments.component';
import { LoginComponent } from './initial/login/login.component';
import { RegisterComponent } from './initial/register/register.component';
import { ResetPassComponent } from './initial/reset-pass/reset-pass.component';
import { ResourceLibraryComponent } from './resource-library/resource-library.component';
import { AnalysisService } from './services/analysis.service';
import { AssessmentService } from './services/assessment.service';
import { AuthenticationService } from './services/authentication.service';
import { ConfigService } from './services/config.service';
import { DemographicService } from './services/demographic.service';
import { EmailService } from './services/email.service';
import { EnableFeatureService } from './services/enable-feature.service';
import { FileUploadClientService } from './services/file-client.service';
import { ObservationsService } from './services/observations.service';
import { FrameworkService } from './services/framework.service';
import { NavigationService } from './services/navigation/navigation.service';
import { QuestionsService } from './services/questions.service';
import { SalService } from './services/sal.service';
import { StandardService } from './services/standard.service';
import { SetListComponent } from './builder/custom-set-list/custom-set-list.component';
import { SetBuilderService } from './services/set-builder.service';
import { CustomSetComponent } from './builder/set-detail/set-detail.component';
import { RequirementListComponent } from './builder/requirement-list/requirement-list.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { QuestionListComponent } from './builder/question-list/question-list.component';
import { RouterModule } from '@angular/router';
import { BuilderBreadcrumbsComponent } from './builder/builder-breadcrumbs/builder-breadcrumbs.component';
import { AddQuestionComponent } from './builder/add-question/add-question.component';
import { RequirementDetailComponent } from './builder/requirement-detail/requirement-detail.component';
import { AddRequirementComponent } from './dialogs/add-requirement/add-requirement/add-requirement.component';
import { AngularEditorModule } from '@kolkov/angular-editor';
import { StandardDocumentsComponent } from './builder/standard-documents/standard-documents.component';
import { RefDocumentComponent } from './builder/ref-document/ref-document.component';
import { RequiredDocumentService } from './services/required-document.service';
import { CurrencyMaskModule } from 'ng2-currency-mask';
import { ResourceLibraryService } from './services/resource-library.service';
import { DiagramComponent } from './assessment/diagram/diagram.component';
import { DiagramInfoComponent } from './assessment/diagram/diagram-info/diagram-info.component';
import { DiagramInventoryComponent } from './assessment/diagram/diagram-inventory/diagram-inventory.component';
import { DiagramComponentsComponent } from './assessment/diagram/diagram-inventory/components/diagram-components.component';
import { LinksComponent } from './assessment/diagram/diagram-inventory/links/links.component';
import { NetworkWarningsComponent } from './assessment/diagram/diagram-inventory/network-warnings/network-warnings.component';
import { ShapesComponent } from './assessment/diagram/diagram-inventory/shapes/shapes.component';
import { TextComponent } from './assessment/diagram/diagram-inventory/text/text.component';
import { ZonesComponent } from './assessment/diagram/diagram-inventory/zones/zones.component';
import { DiagramService } from './services/diagram.service';
import { ExcelExportComponent } from './dialogs/excel-export/excel-export.component';
import { MergeComponent } from './aggregation/merge/merge.component';
import { AggregationService } from './services/aggregation.service';
import { MergeQuestionDetailComponent } from './dialogs/merge-question-detail/merge-question-detail.component';
import { AggregationHomeComponent } from './aggregation/aggregation-home/aggregation-home.component';
import { AliasAssessmentsComponent } from './aggregation/alias-assessments/alias-assessments.component';
import { AggregationDetailComponent } from './aggregation/aggregation-detail/aggregation-detail.component';
import { TrendAnalyticsComponent } from './aggregation/trend-analytics/trend-analytics.component';
import { CompareAnalyticsComponent } from './aggregation/compare-analytics/compare-analytics.component';
import { CompareSummaryComponent } from './aggregation/compare-analytics/standards-based/compare-summary/compare-summary.component';
import { CompareMissedComponent } from './aggregation/compare-analytics/standards-based/compare-missed/compare-missed.component';
import { CompareIndividualComponent } from './aggregation/compare-analytics/standards-based/compare-individual/compare-individual.component';
import { CompareBestworstComponent } from './aggregation/compare-analytics/standards-based/compare-bestworst/compare-bestworst.component';
import { CompareMaturityMissedComponent } from './aggregation/compare-analytics/maturity-based/compare-missed/compare-missed.component';
import { CompareMaturityIndividualComponent } from './aggregation/compare-analytics/maturity-based/compare-individual/compare-individual.component';
import { CompareMaturityBestworstComponent } from './aggregation/compare-analytics/maturity-based/compare-bestworst/compare-bestworst.component';
import { SelectAssessmentsComponent } from './dialogs/select-assessments/select-assessments.component';
import { ChartService } from './services/chart.service';
import { ChartColors } from './services/chart.service';
import { LayoutSwitcherComponent } from './layout/layout-switcher/layout-switcher.component';
import { LayoutBlankComponent } from './layout/layout-blank/layout-blank.component';
import { LayoutMainComponent } from './layout/layout-main/layout-main.component';
import { IodLayoutComponent } from './layout/iod-layout/iod-layout.component';
import { ReportTestComponent } from './reports/report-test/report-test.component';
import { SiteDetailComponent } from './reports/site-detail/site-detail.component';
import { ObservationTearoutsComponent } from './reports/observation-tearouts/observation-tearouts.component';
import { EvalAgainstStandardsComponent } from './reports/eval-against-standards/eval-against-standards.component';
import { ExecutiveSummaryComponent } from './reports/executive-summary/executive-summary.component';
import { SecurityplanComponent } from './reports/securityplan/securityplan.component';
import { SiteSummaryComponent } from './reports/site-summary/site-summary.component';
import { ReportService } from './services/report.service';
import { ReportAnalysisService } from './services/report-analysis.service';
import { LocalStoreManager } from './services/storage.service';
import { TrendReportComponent } from './reports/trend-report/trend-report.component';
import { CompareReportComponent } from './reports/compare-report/compare-report.component';
import { CompareReportMComponent } from './reports/compare-report-m/compare-report-m.component';
import { AwwaStandardComponent } from './assessment/prepare/standards/awwa-standard/awwa-standard.component';
import { ModelSelectComponent } from './assessment/prepare/maturity/model-select/model-select.component';
import { CmmcLevelsComponent } from './assessment/prepare/maturity/cmmc-levels/cmmc-levels.component';
import { Cmmc2LevelsComponent } from './assessment/prepare/maturity/cmmc2-levels/cmmc2-levels.component';
import { CmmcAComponent } from './assessment/prepare/maturity/cmmc-a/cmmc-a.component';
import { CategoryBlockComponent } from './assessment/questions/category-block/category-block.component';
import { MaturityQuestionsComponent } from './assessment/questions/maturity-questions/maturity-questions.component';
import { AskQuestionsComponent } from './assessment/questions/ask-questions/ask-questions.component';
import { CreQuestionSelectorComponent } from './assessment/questions/maturity-questions/cre-question-selector/cre-question-selector.component';
import { CreSubdomainChartsComponent } from './reports/crePlus/cre-subdomain-charts/cre-subdomain-charts.component';
import { CreModelChartsComponent } from './reports/crePlus/cre-model-charts/cre-model-charts.component';
import { CreMilCharts2Component } from './reports/crePlus/cre-mil-charts-2/cre-mil-charts-2.component';
import { CreHeatmapsComponent } from './reports/crePlus/cre-heatmaps/cre-heatmaps.component';
import { DiagramQuestionsComponent } from './assessment/questions/diagram-questions/diagram-questions.component';
import { ExecutiveCMMCComponent } from './reports/cmmc/executive-cmmc/executive-cmmc.component';
import { SitesummaryCMMCComponent } from './reports/cmmc/sitesummary-cmmc/sitesummary-cmmc.component';
import { CmmcLevelResultsComponent } from './assessment/results/mat-cmmc/cmmc-level-results/cmmc-level-results.component';
import { CmmcLevelDrilldownComponent } from './assessment/results/mat-cmmc/cmmc-level-drilldown/cmmc-level-drilldown.component';
import { CmmcComplianceComponent } from './assessment/results/mat-cmmc/cmmc-compliance/cmmc-compliance.component';
import { CmmcGapsComponent } from './assessment/results/mat-cmmc/cmmc-gaps/cmmc-gaps.component';
import { Cmmc2ScoresComponent } from './assessment/results/mat-cmmc2/cmmc2-scores/cmmc2-scores.component';
import { Cmmc2Level1ScoreComponent } from './assessment/results/mat-cmmc2/cmmc2-level1-score/cmmc2-level1-score.component';
import { Cmmc2Level2ScoreComponent } from './assessment/results/mat-cmmc2/cmmc2-level2-score/cmmc2-level2-score.component';
import { Cmmc2Level3ScoreComponent } from './assessment/results/mat-cmmc2/scorecard/cmmc2-level3-score/cmmc2-level3-score.component';
import { Cmmc2ScorecardPageComponent } from './assessment/results/mat-cmmc2/scorecard/cmmc2-scorecard/cmmc2-scorecard-page.component';
import { LevelScorecardComponent } from './assessment/results/mat-cmmc2/scorecard/level-scorecard/level-scorecard.component';
import { Cmmc2LevelResultsComponent } from './assessment/results/mat-cmmc2/cmmc2-level-results/cmmc2-level-results.component';
import { Cmmc2DomainResultsComponent } from './assessment/results/mat-cmmc2/cmmc2-domain-results/cmmc2-domain-results.component';
import { ExecutiveCMMC2Component } from './reports/cmmc2/executive-cmmc2/executive-cmmc2.component';
import { CommonModule } from '@angular/common';
import { NavBackNextComponent } from './assessment/navigation/nav-back-next/nav-back-next.component';
import { CsetOriginComponent } from './initial/cset-origin/cset-origin.component';
import { ComplianceScoreComponent } from './assessment/results/mat-cmmc/chart-components/compliance-score/compliance-score.component';
import { ScoreRangeComponent } from './assessment/results/score-range/score-range.component';
import { ScoreRangesComponent } from './assessment/results/score-ranges/score-ranges.component';
import { CmmcStyleService } from './services/cmmc-style.service';
import { TutorialCmmcComponent } from './assessment/prepare/maturity/tutorial-cmmc/tutorial-cmmc.component';
import { TutorialEdmComponent } from './assessment/prepare/maturity/tutorial-edm/tutorial-edm.component';
import { LoginCsetComponent } from './initial/login-cset/login-cset.component';
import { AboutCsetComponent } from './dialogs/about-cset/about-cset.component';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import { GroupingBlockComponent } from './assessment/questions/grouping-block/grouping-block.component';
import { QuestionBlockMaturityComponent } from './assessment/questions/question-block-maturity/question-block-maturity.component';
import { EdmDeficiencyComponent } from './reports/edm-deficiency/edm-deficiency.component';
import { GeneralDeficiencyComponent } from './reports/general-deficiency/general-deficiency.component';
import { EdmCommentsmarkedComponent } from './reports/edm-commentsmarked/edm-commentsmarked.component';
import { CisCommentsmarkedComponent } from './reports/cis-commentsmarked/cis-commentsmarked.component';
import { EdmComponent } from './reports/edm/edm.component';
import { TooltipModule } from './modules/tooltip/tooltip.module';
import { QuestionTextComponent } from './assessment/questions/question-text/question-text.component';
import { QuestionTextCpgComponent } from './assessment/questions/question-text/question-text-cpg/question-text-cpg.component';
import { CmmcFilteringService } from './services/filtering/maturity-filtering/cmmc-filtering.service';
import { EdmFilteringService } from './services/filtering/maturity-filtering/edm-filtering.service';
import { CrrFilteringService } from './services/filtering/maturity-filtering/crr-filtering.service';
import { RraFilteringService } from './services/filtering/maturity-filtering/rra-filtering.service';
import { GlossaryTermComponent } from './assessment/questions/question-text/glossary-term/glossary-term.component';
import { PlaceholderQuestionsComponent } from './assessment/questions/placeholder-questions/placeholder-questions.component';
import { EdmHeatmapComponent } from './assessment/results/edm/edm-heatmap/edm-heatmap.component';
import { EdmGlossaryComponent } from './reports/edm/edm-glossary/edm-glossary.component';
import { EdmIntroTextComponent } from './reports/edm/edm-intro-text/edm-intro-text.component';
import { EdmTocComponent } from './reports/edm/edm-toc/edm-toc.component';
import { EdmAcronymsComponent } from './reports/edm/edm-acronyms/edm-acronyms.component';
import { EdmSourceReferencesComponent } from './reports/edm/edm-source-references/edm-source-references.component';
import { EdmDomainDetailComponent } from './reports/edm/edm-domain-detail/edm-domain-detail.component';
import { RelationshipFormationComponent } from './assessment/results/edm/relationship-formation/relationship-formation.component';
import { RelationshipManagementComponent } from './assessment/results/edm/relationship-management/relationship-management.component';
import { ServiceProtectionComponent } from './assessment/results/edm/service-protection/service-protection.component';
import { MaturityIndicatorLevelsComponent } from './assessment/results/edm/maturity-indicator-levels/maturity-indicator-levels.component';
import { EDMHorizontalBarChart } from './reports/edm/horizontal-bar-chart/horizontal-bar-chart.component';
import { EDMTripleBarChart } from './reports/edm/triple-bar-chart/triple-bar-chart.component';
import { EDMBarChartLegend } from './reports/edm/edm-bar-chart-legend/edm-bar-chart-legend.component';
import { EDMFrameworkSummary } from './reports/edm/edm-framework-summ/edm-framework-summ.component';
import { ModuleAddCloneComponent } from './builder/module-add-clone/module-add-clone.component';
import { EdmPerfSummMil1Component } from './reports/edm/edm-perf-summ-mil1/edm-perf-summ-mil1.component';
import { EdmPerfSummAllMilComponent } from './reports/edm/edm-perf-summ-all-mil/edm-perf-summ-all-mil.component';
import { EDMAppendixASectionOne } from './reports/edm/edm-appendix-a-1/edm-appendix-a-1.component';
import { EDMAppendixASectionTwo } from './reports/edm/edm-appendix-a-2/edm-appendix-a-2.component';
import { EdmSummaryResultsComponent } from './reports/edm/edm-summary-results/edm-summary-results.component';
import { EdmBlocksCompactComponent } from './assessment/results/edm/edm-blocks-compact/edm-blocks-compact.component';
import { EdmLegendSubquestionsComponent } from './reports/edm/edm-legend-subquestions/edm-legend-subquestions.component';
import { EdmPerfMil1Component } from './reports/edm/edm-perf-mil1/edm-perf-mil1.component';
import { EdmQBlocksHorizontalComponent } from './assessment/results/edm/edm-q-blocks-horizontal/edm-q-blocks-horizontal.component';
import { EDMGoalQuestionSummary } from './reports/edm/edm-goal-question-summary/edm-goal-question-summary.component';
import { GroupingDescriptionComponent } from './assessment/questions/grouping-description/grouping-description.component';
import { SummaryResultsComponent } from './assessment/results/edm/summary-results/summary-results.component';
import { EDMGoalQuestionLegend } from './reports/edm/edm-bar-chart-legend copy/edm-goal-question-legend.component';
import { CmmcDeficiencyComponent } from './reports/cmmc/cmmc-deficiency/cmmc-deficiency.component';
import { CmmcCommentsMarkedComponent } from './reports/cmmc/cmmc-comments-marked/cmmc-comments-marked.component';
import { CmmcAltJustificationsComponent } from './reports/cmmc/cmmc-alt-justifications/cmmc-alt-justifications.component';
import { TutorialCrrComponent } from './assessment/prepare/maturity/tutorial-crr/tutorial-crr.component';
import { CrrDeficiencyComponent } from './reports/crr/crr-deficiency/crr-deficiency.component';
import { CrrCommentsMarkedComponent } from './reports/crr/crr-comments-marked/crr-comments-marked.component';
import { TutorialRraComponent } from './assessment/prepare/maturity/tutorial-rra/tutorial-rra.component';
import { TutorialCpgComponent } from './assessment/prepare/maturity/tutorial-cpg/tutorial-cpg.component';
import { TutorialCpg2Component } from './assessment/prepare/maturity/tutorial-cpg2/tutorial-cpg2.component';
import { TutorialMvraComponent } from './assessment/prepare/maturity/tutorial-mvra/tutorial-mvra.component';
import { RraLevelResultsComponent } from './assessment/results/mat-rra/rra-level-results/rra-level-results.component';
import { RraGapsComponent } from './assessment/results/mat-rra/rra-gaps/rra-gaps.component';
import { RraDeficiencyComponent } from './reports/rra/rra-deficiency/rra-deficiency.component';
import { RraReportComponent } from './reports/rra/rra-report/rra-report.component';
import { CommentsMfrComponent } from './reports/commentsmfr/commentsmfr.component';
import { RraSummaryComponent } from './assessment/results/mat-rra/rra-summary/rra-summary.component';
import { RraSummaryAllComponent } from './assessment/results/mat-rra/rra-summary-all/rra-summary-all.component';
import { ReportDisclaimerComponent } from './reports/general/report-disclaimer/report-disclaimer.component';
import { OnlineDisclaimerComponent } from './dialogs/online-disclaimer/online-disclaimer.component';
import { ReportAdvisoryComponent } from './reports/general/report-advisory/report-advisory.component';
import { RraLevelsComponent } from './assessment/results/mat-rra/rra-levels/rra-levels.component';
import { RraAnswerCountsComponent } from './assessment/results/mat-rra/rra-answer-counts/rra-answer-counts.component';
import { RraAnswerDistributionComponent } from './assessment/results/mat-rra/rra-answer-distribution/rra-answer-distribution.component';
import { RraAnswerComplianceComponent } from './assessment/results/mat-rra/rra-answer-compliance/rra-answer-compliance.component';
import { RraQuestionsScoringComponent } from './assessment/results/mat-rra/rra-questions-scoring/rra-questions-scoring.component';
import { RraMiniUserGuideComponent } from './dialogs/rra-mini-user-guide/rra-mini-user-guide.component';
import { CrrSummaryResultsComponent } from './assessment/results/crr/crr-summary-results/crr-summary-results.component';
import { CrrResultsPage } from './assessment/results/crr/crr-results-page/crr-results-page.component';
import { CrrResultsDetailComponent } from './assessment/results/crr/crr-results-detail/crr-results-detail.component';
import { CrrHeatmapComponent } from './assessment/results/crr/crr-heatmap/crr-heatmap.component';
import { CmuService } from './services/cmu.service';
import { Utilities } from './services/utilities.service';
import { RunScriptsDirective } from './helpers/run-scripts.directive';
import { MatCommentsComponent } from './reports/edm/mat-comments/mat-comments.component';
import { TsaAssessmentCompleteComponent } from './assessment/results/tsa-assessment-complete/tsa-assessment-complete.component';
import { SprsScoreComponent } from './assessment/results/mat-cmmc2/scorecard/sprs-score/sprs-score.component';
import { TutorialCmmc2Component } from './assessment/prepare/maturity/tutorial-cmmc2/tutorial-cmmc2.component';
import { TopMenusComponent } from './layout/top-menus/top-menus.component';
import { LogoCsetComponent } from './layout/logos/logo-cset/logo-cset.component';
import { LogoForReportsComponent } from './reports/logo-for-reports/logo-for-reports.component';
import { QuestionBlockVadrComponent } from './assessment/questions/question-block-vadr/question-block-vadr.component';
import { VadrDeficiencyComponent } from './reports/vadr/vadr-deficiency/vadr-deficiency.component';
import { CsiComponent } from './assessment/prepare/csi/csi.component';
import { CsiOrganizationDemographicsComponent } from './assessment/prepare/csi/csi-organization-demographics/csi-organization-demographics.component';
import { CsiServiceDemographicsComponent } from './assessment/prepare/csi/csi-service-demographics/csi-service-demographics.component';
import { CsiServiceCompositionComponent } from './assessment/prepare/csi/csi-service-composition/csi-service-composition.component';
import { AssessmentComparisonAnalyticsComponent } from './initial/assessmenet-comparison-analytics/assessment-comparison-analytics.component';
import { MaturityQuestionsNestedComponent } from './assessment/questions/maturity-questions/nested/maturity-questions-nested/maturity-questions-nested.component';
import { QuestionBlockNestedComponent } from './assessment/questions/maturity-questions/nested/question-block-nested/question-block-nested.component';
import { GroupingBlockNestedComponent } from './assessment/questions/maturity-questions/nested/grouping-block-nested/grouping-block-nested.component';
import { OptionBlockNestedComponent } from './assessment/questions/maturity-questions/nested/option-block-nested/option-block-nested.component';
import { ModuleContentLaunchComponent } from './reports/module-content/module-content-launch/module-content-launch.component';
import { ModuleContentComponent } from './reports/module-content/module-content/module-content.component';
import { TutorialCisComponent } from './assessment/prepare/maturity/tutorial-cis/tutorial-cis.component';
import { QuestionExtrasDialogComponent } from './assessment/questions/question-extras-dialog/question-extras-dialog.component';
import { VadrReportComponent } from './reports/vadr/vadr-report/vadr-report.component';
import { VadrAnswerComplianceComponent } from './assessment/results/mat-vadr/vadr-answer-compliance/vadr-answer-compliance.component';
import { VadrAnswerCountsComponent } from './assessment/results/mat-vadr/vadr-answer-counts/vadr-answer-counts.component';
import { VadrAnswerDistributionComponent } from './assessment/results/mat-vadr/vadr-answer-distribution/vadr-answer-distribution.component';
import { VadrGapsComponent } from './assessment/results/mat-vadr/vadr-gaps/vadr-gaps.component';
import { VadrLevelResultsComponent } from './assessment/results/mat-vadr/vadr-level-results/vadr-level-results.component';
import { VadrLevelsComponent } from './assessment/results/mat-vadr/vadr-levels/vadr-levels.component';
import { VadrQuestionsScoringComponent } from './assessment/results/mat-vadr/vadr-questions-scoring/vadr-questions-scoring.component';
import { VadrSummaryComponent } from './assessment/results/mat-vadr/vadr-summary/vadr-summary.component';
import { VadrSummaryAllComponent } from './assessment/results/mat-vadr/vadr-summary-all/vadr-summary-all.component';
import { OpenEndedQuestionsComponent } from './reports/vadr/open-ended-questions/open-ended-questions.component';
import { CisSurveyComponent } from './reports/cis/cis-survey/cis-survey.component';
import { GroupingBlockNestedReportComponent } from './reports/cis/grouping-block-nested-report/grouping-block-nested-report.component';
import { QuestionBlockNestedReportComponent } from './reports/cis/question-block-nested-report/question-block-nested-report.component';
import { OptionBlockNestedReportComponent } from './reports/cis/option-block-nested-report/option-block-nested-report.component';
import { CoverSheetAComponent } from './reports/cis/shared/cover-sheet-a/cover-sheet-a.component';
import { DisclaimerBlurbAComponent } from './reports/cis/shared/disclaimer-blurb-a/disclaimer-blurb-a.component';
import { ConfigCisComponent } from './assessment/prepare/maturity/config-cis/config-cis.component';
import { CisRankedDeficiencyComponent } from './reports/cis/cis-ranked-deficiency/cis-ranked-deficiency.component';
import { RankedDeficiencyChartComponent } from './assessment/results/cis/ranked-deficiency-chart/ranked-deficiency-chart.component';
import { RankedDeficiencyComponent } from './assessment/results/cis/ranked-deficiency/ranked-deficiency.component';
import { CisSectionScoringComponent } from './reports/cis/cis-section-scoring/cis-section-scoring.component';
import { CisScoringChartComponent } from './reports/cis/cis-section-scoring/cis-scoring-chart/cis-scoring-chart.component';
import { SectionScoringComponent } from './assessment/results/cis/section-scoring/section-scoring.component';
import { CharterMismatchComponent } from './dialogs/charter-mistmatch/charter-mismatch.component';
import { DigitsOnlyNotZeroDirective } from './helpers/digits-only-not-zero.directive';
import { LandingPageTabsComponent } from './initial/landing-page-tabs/landing-page-tabs.component';
import { ModuleContentStandardComponent } from './reports/module-content/module-content-standard/module-content-standard.component';
import { ModuleContentModelComponent } from './reports/module-content/model/module-content-model/module-content-model.component';
import { McGroupingComponent } from './reports/module-content/model/mc-grouping/mc-grouping.component';
import { McQuestionComponent } from './reports/module-content/model/mc-question/mc-question.component';
import { McOptionComponent } from './reports/module-content/model/mc-option/mc-option.component';
import { GuidanceBlockComponent } from './reports/module-content/guidance-block/guidance-block.component';
import { ReferencesBlockComponent } from './reports/module-content/references-block/references-block.component';
import { NewAssessmentDialogComponent } from './dialogs/new-assessment-dialog/new-assessment-dialog.component';
import { GalleryService } from './services/gallery.service';
import { EllipsisModule } from './modules/ngx-ellipsis/ellipsis.module';
import { CrrReportComponent } from './reports/crr/crr-report/crr-report.component';
import { CrrCoverSheetComponent } from './reports/crr/crr-report/crr-cover-sheet/crr-cover-sheet.component';
import { CrrCoverSheet2Component } from './reports/crr/crr-report/crr-cover-sheet2/crr-cover-sheet2.component';
import { CrrIntroAboutComponent } from './reports/crr/crr-report/crr-intro-about/crr-intro-about.component';
import { CrrMil1PerformanceSummaryComponent } from './reports/crr/crr-report/crr-mil1-performance-summary/crr-mil1-performance-summary.component';
import { CrrPerformanceSummaryComponent } from './reports/crr/crr-report/crr-performance-summary/crr-performance-summary.component';
import { CrrNistCsfSummaryComponent } from './reports/crr/crr-report/crr-nist-csf-summary/crr-nist-csf-summary.component';
import { CrrMil1PerformanceComponent } from './reports/crr/crr-report/crr-mil1-performance/crr-mil1-performance.component';
import { CrrMilByDomainComponent } from './reports/crr/crr-report/crr-mil-by-domain/crr-mil-by-domain.component';
import { CrrPercentageOfPracticesComponent } from './reports/crr/crr-report/crr-percentage-of-practices/crr-percentage-of-practices.component';
import { CrrDomainDetailComponent } from './reports/crr/crr-report/crr-domain-detail/crr-domain-detail.component';
import { CrrResourcesComponent } from './reports/crr/crr-report/crr-resources/crr-resources.component';
import { CrrContactInformationComponent } from './reports/crr/crr-report/crr-contact-information/crr-contact-information.component';
import { CrrAppendixACoverComponent } from './reports/crr/crr-report/crr-appendix-a-cover/crr-appendix-a-cover.component';
import { CrrPerformanceAppendixAComponent } from './reports/crr/crr-report/crr-performance-appendix-a/crr-performance-appendix-a.component';
import { CrrNistCsfCatSummaryComponent } from './reports/crr/crr-report/crr-nist-csf-cat-summary/crr-nist-csf-cat-summary.component';
import { CmuNistCsfCatSummaryComponent } from './reports/cmu/cmu-nist-csf-cat-summary/cmu-nist-csf-cat-summary.component';
import { CrrNistCsfCatPerformanceComponent } from './reports/crr/crr-report/crr-nist-csf-cat-performance/crr-nist-csf-cat-performance.component';
import { CmuNistCsfCatPerformanceComponent } from './reports/cmu/cmu-nist-csf-cat-performance/cmu-nist-csf-cat-performance.component';
import { CrrSideTocComponent } from './reports/crr/crr-report/crr-side-toc/crr-side-toc.component';
import { CrrMainTocComponent } from './reports/crr/crr-report/crr-main-toc/crr-main-toc.component';
import { CreFinalReportComponent } from './reports/crePlus/cre-final-report/cre-final-report.component';
import { CreFinalReportGridComponent } from './reports/crePlus/cre-final-report-grid/cre-final-report-grid.component';
import { CreAssessmentOverview } from './reports/crePlus/cre-assessment-overview/cre-assessment-overview.component';
import { Cmmc2CommentsMarkedComponent } from './reports/cmmc2/cmmc2-comments-marked/cmmc2-comments-marked.component';
import { Cmmc2DeficiencyComponent } from './reports/cmmc2/cmmc2-deficiency/cmmc2-deficiency.component';
import { Cmmc2ScorecardReportComponent } from './reports/cmmc2/cmmc2-scorecard-report/cmmc2-scorecard-report.component';
import { PrivacyWarningComponent } from './initial/privacy-warning/privacy-warning.component';
import { PrivacyWarningRejectComponent } from './initial/privacy-warning-reject/privacy-warning-reject.component';
import { IssuesComponent } from './assessment/questions/issues/issues.component';
import { SearchPageComponent } from './initial/search-page/search-page.component';
import { LogoTsaComponent } from './layout/logos/logo-tsa/logo-tsa.component';
import { OptionBlockComponent } from './assessment/questions/maturity-questions/option-block/option-block.component';
import { DemographicsExtendedComponent } from './assessment/prepare/assessment-info/demographics-extended/demographics-extended.component';
import { DemographicExtendedService } from './services/demographic-extended.service';
import { SectorHelpComponent } from './dialogs/sector-help/sector-help.component';
import { AnalyticsCompareComponent } from './assessment/results/analytics-compare/analytics-compare.component';
import { MvraGapsComponent } from './assessment/results/mat-mvra/mvra-gaps/mvra-gaps.component';
import { MvraSummaryComponent } from './assessment/results/mat-mvra/mvra-summary/mvra-summary.component';
import { MvraAnswerFunctionsComponent } from './assessment/results/mat-mvra/mvra-answer-functions/mvra-answer-functions.component';
import { MvraAnswerDomainsComponent } from './assessment/results/mat-mvra/mvra-answer-domains/mvra-answer-domains.component';
import { ZipCodeDirective } from './helpers/zip-code.directive';
import { MvraReportComponent } from './reports/mvra/mvra-report.component';
import { MvraSummaryPageComponent } from './assessment/results/mat-mvra/mvra-summary-page/mvra-summary-page.component';
import { MvraGapsPageComponent } from './assessment/results/mat-mvra/mvra-gaps-page/mvra-gaps-page.component';
import { LoginAccessKeyComponent } from './initial/login-access-key/login-access-key.component';
import { RelatedQBlockComponent } from './reports/module-content/related-q-block/related-q-block.component';
import { CpgReportComponent } from './reports/cpg/cpg-report/cpg-report.component';
import { CpgPracticeTableComponent } from './assessment/results/cpg/cpg-practice-table/cpg-practice-table.component';
import { LogoutComponent } from './initial/logout/logout.component';
import { CpgDomainSummaryComponent } from './assessment/results/cpg/cpg-domain-summary/cpg-domain-summary.component';
import { CpgCostImpactComplexityComponent } from './assessment/results/cpg/cpg-cost-impact-complexity/cpg-cost-impact-complexity.component';
import { CpgSummaryComponent } from './assessment/results/cpg/cpg-summary/cpg-summary.component';
import { CpgPracticesComponent } from './assessment/results/cpg/cpg-practices/cpg-practices.component';
import { ReferencesTableComponent } from './assessment/questions/references-table/references-table.component';
import { ReferencesDisplayComponent } from './assessment/questions/references-display/references-display.component';
import { DiagramVulnerabilitiesDialogComponent } from './assessment/diagram/diagram-inventory/vulnerabilities/diagram-vulnerabilities-dialog/diagram-vulnerabilities-dialog';
import { DiagramVulnerabilitiesComponent } from './assessment/diagram/diagram-inventory/vulnerabilities/diagram-vulnerabilities.component';
import { AnalysisNetworkComponentsComponent } from './reports/analysis-network-components/analysis-network-components.component';
import { SalSectionComponent } from './reports/sal-section/sal-section.component';
import { AltJustificationCommentsComponent } from './reports/alt-justification-comments/alt-justification-comments.component';
import { QuestionCommentsComponent } from './reports/question-comments/question-comments.component';
import { QuestionsMarkedForReviewComponent } from './reports/questions-marked-for-review/questions-marked-for-review.component';
import { StandardsComplianceComponent } from './reports/standards-compliance/standards-compliance.component';
import { ComponentComplianceComponent } from './reports/component-compliance/component-compliance.component';
import { OverallComplianceComponent } from './reports/overall-compliance/overall-compliance.component';
import { RankedSubjectAreasComponent } from './reports/ranked-subject-areas/ranked-subject-areas.component';
import { DocumentLibraryComponent } from './reports/document-library/document-library.component';
import { ComponentQuestionListComponent } from './reports/component-question-list/component-question-list.component';
import { C2m2ReportComponent } from './reports/c2m2/c2m2-report/c2m2-report.component';
import { C2m2CoverSheetComponent } from './reports/c2m2/c2m2-report/c2m2-cover-sheet/c2m2-cover-sheet.component';
import { C2m2IntroductionComponent } from './reports/c2m2/c2m2-report/c2m2-introduction/c2m2-introduction.component';
import { C2m2ModelArchitectureComponent } from './reports/c2m2/c2m2-report/c2m2-model-architecture/c2m2-model-architecture.component';
import { C2m2SummaryResultsComponent } from './reports/c2m2/c2m2-report/c2m2-summary-results/c2m2-summary-results.component';
import { C2m2DetailedResultsComponent } from './reports/c2m2/c2m2-report/c2m2-detailed-results/c2m2-detailed-results.component';
import { C2m2UsingSelfEvaluationResultsComponent } from './reports/c2m2/c2m2-report/c2m2-using-self-evaluation-results/c2m2-using-self-evaluation-results.component';
import { C2m2SelfEvaluationNotesComponent } from './reports/c2m2/c2m2-report/c2m2-self-evaluation-notes/c2m2-self-evaluation-notes.component';
import { C2m2ListOfPartiallyImplementedAndNotImplementedPracticesComponent } from './reports/c2m2/c2m2-report/c2m2-list-of-partially-implemented-and-not-implemented-practices/c2m2-list-of-partially-implemented-and-not-implemented-practices.component';
import { C2m2SideTocComponent } from './reports/c2m2/c2m2-report/c2m2-side-toc/c2m2-side-toc.component';
import { C2m2DonutComponent } from './reports/c2m2/c2m2-donut/c2m2-donut.component';
import { C2m2ObjectiveTableComponent } from './reports/c2m2/c2m2-objective-table/c2m2-objective-table.component';
import { CpgDomainSummaryTableComponent } from './assessment/results/cpg/cpg-domain-summary-table/cpg-domain-summary-table.component';
import { C2m2DomainMilBarChartComponent } from './reports/c2m2/c2m2-report/c2m2-summary-results/c2m2-domain-mil-bar-chart/c2m2-domain-mil-bar-chart.component';
import { CpgDeficiencyComponent } from './reports/cpg/cpg-deficiency/cpg-deficiency.component';
import { PdfReportsComponent } from './reports/pdf-reports/pdf-reports.component';
import { InfoBlockComponent } from './reports/info-block/info-block.component';
import { SiteInformationComponent } from './reports/site-information/site-information.component';
import { LogoCyberShieldComponent } from './layout/logos/logo-cyber-shield/logo-cyber-shield.component';
import { ExportAssessmentComponent } from './dialogs/assessment-encryption/export-assessment/export-assessment.component';
import { ImportPasswordComponent } from './dialogs/assessment-encryption/import-password/import-password.component';
import { HydroDeficiencyComponent } from './assessment/results/hydro/hydro-deficiency/hydro-deficiency.component';
import { HydroDonutComponent } from './assessment/results/hydro/hydro-donut/hydro-donut.component';
import { HydroBarChartComponent } from './assessment/results/hydro/hydro-bar-chart/hydro-bar-chart.component';
import { HydroReportComponent } from './reports/hydro/hydro-report/hydro-report.component';
import { HydroSideTocComponent } from './reports/hydro/hydro-report/hydro-side-toc/hydro-side-toc.component';
import { HydroAcronymsComponent } from './reports/hydro/hydro-report/hydro-acronyms/hydro-acronyms.component';
import { HydroExecutiveSummaryComponent } from './reports/hydro/hydro-report/hydro-executive-summary/hydro-executive-summary.component';
import { HydroImportanceOfCybersecurityComponent } from './reports/hydro/hydro-report/hydro-importance-of-cybersecurity/hydro-importance-of-cybersecurity.component';
import { HydroResultsSummaryComponent } from './reports/hydro/hydro-report/hydro-results-summary/hydro-results-summary.component';
import { HydroConsequencesComponent } from './reports/hydro/hydro-report/hydro-consequences/hydro-consequences.component';
import { HydroImpactCategoryComponent } from './reports/hydro/hydro-report/hydro-impact-category/hydro-impact-category.component';
import { HydroFeasibilityReportComponent } from './reports/hydro/hydro-report/hydro-report-feasibility/hydro-report-feasibility.component';
import { HydroBarVerticalComponent } from './assessment/results/hydro/hydro-bar-vertical/hydro-bar-vertical.component';
import { HydroImpactComponent } from './assessment/results/hydro/hydro-impact/hydro-impact.component';
import { HydroFeasibilityComponent } from './assessment/results/hydro/hydro-feasibility/hydro-feasibility.component';
import { HydroActionsComponent } from './assessment/results/hydro/hydro-actions/hydro-actions.component';
import { HydroActionItemComponent } from './assessment/results/hydro/hydro-actions/hydro-action-item/hydro-action-item.component';
import { HydroProgressTotalsComponent } from './assessment/results/hydro/hydro-actions/hydro-progress-totals/hydro-progress-totals.component';
import { HydroActionItemsReportComponent } from './reports/hydro/hydro-action-items-report/hydro-action-items-report.component';
import { SdAnswerSummaryComponent } from './assessment/results/sd/sd-answer-summary/sd-answer-summary.component';
import { SdAnswerSummaryReportComponent } from './reports/sd/sd-answer-summary-report/sd-answer-summary-report.component';
import { KeyReportComponent } from './assessment/results/reports/key-report/key-report.component';
import { ImrReportComponent } from './reports/imr/imr-report/imr-report.component';
import { CmuPerformanceComponent } from './reports/cmu/cmu-performance/cmu-performance.component';
import { CmuGoalPerfStackedBarComponent } from './reports/cmu/cmu-goal-perf-stacked-bar/cmu-goal-perf-stacked-bar.component';
import { CmuResultsDetailComponent } from './reports/cmu/cmu-domain-detail-table/cmu-domain-detail-table.component';
import { CmuNistCsfSummaryComponent } from './reports/cmu/cmu-nist-csf-summary/cmu-nist-csf-summary.component';
import { AssessmentConfigIodComponent } from './assessment/prepare/assessment-info/assessment-config-iod/assessment-config-iod.component';
import { AssessmentDemogIodComponent } from './assessment/prepare/assessment-info/assessment-demog-iod/assessment-demog-iod.component';
import { DemographicsIodComponent } from './assessment/prepare/assessment-info/demographics-iod/demographics-iod.component';
import { TutorialImrComponent } from './assessment/prepare/maturity/tutorial-imr/tutorial-imr.component';
import { ImrCoverSheetComponent } from './reports/imr/imr-cover-sheet/imr-cover-sheet.component';
import { ImrIntroAboutComponent } from './reports/imr/imr-intro-about/imr-intro-about.component';
import { ImrResourcesComponent } from './reports/imr/imr-resources/imr-resources.component';
import { CmuDomainComplianceComponent } from './reports/cmu/cmu-domain-compliance/cmu-domain-compliance.component';
import { TsaSdComponent } from './reports/tsa-sd/tsa-sd.component';
import { ImrSideTocComponent } from './reports/imr/imr-side-toc/imr-side-toc.component';
import { CmuAppendixCoverComponent } from './reports/cmu/cmu-appendix-cover/cmu-appendix-cover.component';
import { OtherRemarksComponent } from './assessment/questions/other-remarks/other-remarks.component';
import { CmuOtherRemarksComponent } from './reports/cmu/cmu-other-remarks/cmu-other-remarks.component';
import { TranslocoRootModule } from './transloco-root.module';
import { TranslocoService } from '@jsverse/transloco';
import { provideTranslocoScope } from '@jsverse/transloco';
import { UserSettingsComponent } from './dialogs/user-settings/user-settings.component';
import { MalcolmUploadErrorComponent } from './dialogs/malcolm/malcolm-upload-error.component';
import { FooterService } from './services/footer.service';
import { TrendCompareCompatibilityComponent } from './aggregation/trend-analytics/trend-compare-compatibility/trend-compare-compatibility.component';
import { PrincipleSummaryComponent } from './assessment/questions/principle-summary/principle-summary.component';
import { MalcolmAnswerDefaultComponent } from './assessment/questions/malcolm-answer/malcolm-answer-default/malcolm-answer-default.component';
import { MalcolmAnswerNestedComponent } from './assessment/questions/malcolm-answer/malcolm-answer-nested/malcolm-answer-nested.component';
import { MalcolmInstructionsComponent } from './dialogs/malcolm/malcolm-instructions/malcolm-instructions.component';
import { SdOwnerDeficiencyComponent } from './reports/sd-owner/sd-owner-deficiency/sd-owner-deficiency.component';
import { SdOwnerCommentsMfrComponent } from './reports/sd-owner/sd-owner-comments/sd-owner-comments-mfr.component';
import { ReferencesSectionComponent } from './assessment/questions/references-section/references-section.component';
import { CisaWorkflowWarningsComponent } from './assessment/results/reports/cisa-workflow-warnings/cisa-workflow-warnings.component';
import { AnalyticsComponent } from './assessment/results/analytics/analytics.component';
import { AnalyticsloginComponent } from './assessment/results/analysis/analytics-login/analytics-login.component';
import { AnalyticsService } from './services/analytics.service';
import { UploadDemographicsComponent } from './dialogs/import demographics/import-demographics.component';
import { ReportListComponent } from './assessment/results/reports/report-list/report-list.component';
import { ReportListCommonComponent } from './assessment/results/reports/report-list/report-list-common.component';
import { PhysicalSummaryComponent } from './reports/physical-summary/physical-summary.component';
import { ContactTooltipComponent } from './assessment/prepare/assessment-info/assessment-contacts/contact-tooltip/contact-tooltip.component';
import { NoServerConnectionComponent } from './initial/no-server-connection/no-server-connection.component';
import { AllAnsweredquestionsComponent } from './reports/all-answeredquestions/all-answeredquestions.component';
import { AllCommentsmarkedComponent } from './reports/all-commentsmarked/all-commentsmarked.component';
import { AllReviewedComponent } from './reports/all-reviewed/all-reviewed.component';
import { QuestionsReviewedComponent } from './reports/questions-reviewed/questions-reviewed.component';
import { RolesChangedComponent } from './dialogs/roles-changed/roles-changed.component';
import { AnalyticsResultsComponent } from './assessment/results/analytics-results/analytics-results.component';
import { firstValueFrom } from 'rxjs';
import { UpgradeComponent } from './assessment/upgrade/upgrade.component';
import { CodeEditorModule, provideCodeEditor } from '@ngstack/code-editor';
import { ImportComponent } from './import/import.component';
import { NewAssessmentComponent } from './initial/new-assessment/new-assessment.component';
import { register as registerSwiper } from 'swiper/element/bundle';
import { AdminSettingsComponent } from './initial/admin-settings/admin-settings.component';
import { UserService } from './services/user.service';
import { CisaVadrReportComponent } from './reports/cisa-vadr/cisa-vadr-report/cisa-vadr-report.component';
import { VadrGroupingBlockComponent } from './reports/cisa-vadr/vadr-grouping-block/vadr-grouping-block.component';
import { CisaVadrLevelsComponent } from './assessment/prepare/maturity/cisa-vadr-levels/cisa-vadr-levels.component';
import { CisaVadrInfoComponent } from './assessment/prepare/maturity/cisa-vadr-info/cisa-vadr-info.component';



registerSwiper();

@NgModule({
    declarations: [
        AppComponent,
        InitialComponent,
        LoginComponent,
        MyAssessmentsComponent,
        AssessmentComponent,
        ContactItemComponent,
        PrepareComponent,
        AssessmentInfoComponent,
        AssessmentDetailComponent,
        AssessmentContactsComponent,
        AssessmentDemographicsComponent,
        ResultsComponent,
        SalSimpleComponent,
        ResetPassComponent,
        EmailComponent,
        ConfirmEqualValidatorDirective,
        EmailValidatorDirective,
        FocusDirective,
        ZipCodeDirective,
        AutoSizeDirective,
        DigitsOnlyDirective,
        RunScriptsDirective,
        SalGenComponent,
        SalNistComponent,
        SalsComponent,
        RegisterComponent,
        EjectionComponent,
        ChangePasswordComponent,
        EditUserComponent,
        AlertComponent,
        ConfirmComponent,
        FrameworkComponent,
        RequiredDocsComponent,
        DiagramComponent,
        AboutComponent,
        AdvisoryComponent,
        QuestionsComponent,
        QuestionBlockComponent,
        QuestionExtrasComponent,
        ResourceLibraryComponent,
        OkayComponent,
        ObservationsComponent,
        IssuesComponent,
        SafePipe,
        LinebreakPipe,
        CompletionCountPipe,
        LocalizeDatePipe,
        LinebreakPlaintextPipe,
        NullishCoalescePipe,
        StatusCreateComponent,
        ProgressComponent,
        InViewComponent,
        AnalysisComponent,
        ReportsComponent,
        OverviewComponent,
        StandardsSummaryComponent,
        StandardsRankedComponent,
        StandardsResultsComponent,
        ComponentsSummaryComponent,
        ComponentsRankedComponent,
        ComponentsResultsComponent,
        ComponentsTypesComponent,
        ComponentsWarningsComponent,
        DashboardComponent,
        RankedQuestionsComponent,
        FeedbackComponent,
        EnableProtectedComponent,
        TermsOfUseComponent,
        AccessibilityStatementComponent,
        QuestionFiltersComponent,
        QuestionFiltersReportsComponent,
        AssessmentDocumentsComponent,
        InlineParameterComponent,
        GlobalParametersComponent,
        UploadExportComponent,
        UploadDemographicsComponent,
        KeyboardShortcutsComponent,
        LicenseComponent,
        SetListComponent,
        CustomSetComponent,
        RequirementListComponent,
        QuestionListComponent,
        BuilderBreadcrumbsComponent,
        AddQuestionComponent,
        RequirementDetailComponent,
        AddRequirementComponent,
        StandardDocumentsComponent,
        RefDocumentComponent,
        DiagramInventoryComponent,
        DiagramInfoComponent,
        DiagramComponentsComponent,
        LinksComponent,
        NetworkWarningsComponent,
        ShapesComponent,
        TextComponent,
        ZonesComponent,
        ExcelExportComponent,
        MergeComponent,
        MergeQuestionDetailComponent,
        AggregationHomeComponent,
        AliasAssessmentsComponent,
        AggregationDetailComponent,
        TrendAnalyticsComponent,
        CompareAnalyticsComponent,
        SelectAssessmentsComponent,
        CompareSummaryComponent,
        CompareMissedComponent,
        CompareIndividualComponent,
        CompareBestworstComponent,
        CompareMaturityMissedComponent,
        CompareMaturityIndividualComponent,
        CompareMaturityBestworstComponent,
        ComponentOverrideComponent,
        ExcelExportComponent,
        LayoutBlankComponent,
        LayoutSwitcherComponent,
        LayoutMainComponent,
        ReportTestComponent,
        SiteDetailComponent,
        ObservationTearoutsComponent,
        EvalAgainstStandardsComponent,
        ExecutiveSummaryComponent,
        SecurityplanComponent,
        SiteSummaryComponent,
        PhysicalSummaryComponent,
        TrendReportComponent,
        TrendCompareCompatibilityComponent,
        CompareReportComponent,
        CompareReportMComponent,
        Assessment2InfoComponent,
        ModelSelectComponent,
        AssessmentConfigComponent,
        CmmcAComponent,
        CmmcLevelsComponent,
        Cmmc2LevelsComponent,
        CmmcLevelResultsComponent,
        CmmcLevelDrilldownComponent,
        CmmcComplianceComponent,
        CmmcGapsComponent,
        Cmmc2ScoresComponent,
        Cmmc2Level1ScoreComponent,
        Cmmc2Level2ScoreComponent,
        Cmmc2Level3ScoreComponent,
        Cmmc2ScorecardPageComponent,
        LevelScorecardComponent,
        Cmmc2LevelResultsComponent,
        Cmmc2DomainResultsComponent,
        SprsScoreComponent,
        ComplianceScoreComponent,
        ScoreRangeComponent,
        ScoreRangesComponent,
        ModelSelectComponent,
        CategoryBlockComponent,
        AskQuestionsComponent,
        CreQuestionSelectorComponent,
        MaturityQuestionsComponent,
        AwwaStandardComponent,
        DiagramQuestionsComponent,
        SitesummaryCMMCComponent,
        ExecutiveCMMCComponent,
        ExecutiveCMMC2Component,
        NavBackNextComponent,
        CsetOriginComponent,
        TutorialCmmcComponent,
        TutorialEdmComponent,
        TutorialRraComponent,
        TutorialCrrComponent,
        TutorialCpgComponent,
        TutorialCpg2Component,
        TutorialMvraComponent,
        LoginCsetComponent,
        AboutCsetComponent,
        GroupingBlockComponent,
        QuestionBlockMaturityComponent,
        EdmComponent,
        EdmDeficiencyComponent,
        GeneralDeficiencyComponent,
        EdmCommentsmarkedComponent,
        CisCommentsmarkedComponent,
        QuestionTextComponent,
        QuestionTextCpgComponent,
        GlossaryTermComponent,
        PlaceholderQuestionsComponent,
        EdmHeatmapComponent,
        EdmGlossaryComponent,
        EdmIntroTextComponent,
        EdmTocComponent,
        EdmAcronymsComponent,
        EdmSourceReferencesComponent,
        EdmDomainDetailComponent,
        RelationshipFormationComponent,
        RelationshipManagementComponent,
        ServiceProtectionComponent,
        MaturityIndicatorLevelsComponent,
        EDMTripleBarChart,
        EDMHorizontalBarChart,
        EDMBarChartLegend,
        ModuleAddCloneComponent,
        EdmPerfSummMil1Component,
        EdmPerfSummAllMilComponent,
        EDMFrameworkSummary,
        EDMAppendixASectionOne,
        EDMAppendixASectionTwo,
        EdmBlocksCompactComponent,
        EdmSummaryResultsComponent,
        EdmBlocksCompactComponent,
        EdmLegendSubquestionsComponent,
        EdmPerfMil1Component,
        EdmQBlocksHorizontalComponent,
        EDMGoalQuestionSummary,
        GroupingDescriptionComponent,
        SummaryResultsComponent,
        EDMGoalQuestionLegend,
        CmmcDeficiencyComponent,
        CmmcCommentsMarkedComponent,
        CmmcAltJustificationsComponent,
        CrrDeficiencyComponent,
        CrrCommentsMarkedComponent,
        RraGapsComponent,
        RraLevelResultsComponent,
        RraReportComponent,
        RraDeficiencyComponent,
        RraSummaryAllComponent,
        RraSummaryComponent,
        CommentsMfrComponent,
        ReportDisclaimerComponent,
        ReportAdvisoryComponent,
        RraLevelsComponent,
        RraAnswerCountsComponent,
        RraAnswerDistributionComponent,
        RraAnswerComplianceComponent,
        RraQuestionsScoringComponent,
        RraMiniUserGuideComponent,
        CrrSummaryResultsComponent,
        CrrResultsPage,
        CrrResultsDetailComponent,
        CrrHeatmapComponent,
        MatCommentsComponent,
        TsaAssessmentCompleteComponent,
        TutorialCmmc2Component,
        TopMenusComponent,
        IodLayoutComponent,
        LogoCsetComponent,
        TopMenusComponent,
        LogoForReportsComponent,
        LogoForReportsComponent,
        QuestionBlockVadrComponent,
        VadrDeficiencyComponent,
        CsiComponent,
        CsiOrganizationDemographicsComponent,
        CsiServiceDemographicsComponent,
        CsiServiceCompositionComponent,
        AssessmentComparisonAnalyticsComponent,
        MaturityQuestionsNestedComponent,
        QuestionBlockNestedComponent,
        GroupingBlockNestedComponent,
        OptionBlockNestedComponent,
        ModuleContentComponent,
        ModuleContentLaunchComponent,
        TutorialCisComponent,
        QuestionExtrasDialogComponent,
        VadrReportComponent,
        VadrAnswerComplianceComponent,
        VadrAnswerCountsComponent,
        VadrAnswerDistributionComponent,
        VadrGapsComponent,
        VadrLevelResultsComponent,
        VadrLevelsComponent,
        VadrQuestionsScoringComponent,
        VadrSummaryComponent,
        VadrSummaryAllComponent,
        CisaVadrInfoComponent,
        CisaVadrLevelsComponent,
        CisaVadrReportComponent,
        VadrGroupingBlockComponent,
        OpenEndedQuestionsComponent,
        CisSurveyComponent,
        GroupingBlockNestedReportComponent,
        QuestionBlockNestedReportComponent,
        OptionBlockNestedReportComponent,
        CoverSheetAComponent,
        DisclaimerBlurbAComponent,
        ConfigCisComponent,
        CisRankedDeficiencyComponent,
        RankedDeficiencyChartComponent,
        CisCommentsmarkedComponent,
        RankedDeficiencyComponent,
        CisSectionScoringComponent,
        CisScoringChartComponent,
        SectionScoringComponent,
        CharterMismatchComponent,
        DigitsOnlyNotZeroDirective,
        LandingPageTabsComponent,
        ModuleContentStandardComponent,
        ModuleContentModelComponent,
        McGroupingComponent,
        McQuestionComponent,
        McOptionComponent,
        GuidanceBlockComponent,
        ReferencesBlockComponent,
        CrrReportComponent,
        CrrCoverSheetComponent,
        CrrCoverSheet2Component,
        CrrIntroAboutComponent,
        CrrMil1PerformanceSummaryComponent,
        CrrPerformanceSummaryComponent,
        CrrNistCsfSummaryComponent,
        CrrMil1PerformanceComponent,
        CrrMilByDomainComponent,
        CrrPercentageOfPracticesComponent,
        CrrDomainDetailComponent,
        CrrResourcesComponent,
        CrrContactInformationComponent,
        CrrAppendixACoverComponent,
        CrrPerformanceAppendixAComponent,
        CrrNistCsfCatSummaryComponent,
        CrrNistCsfCatPerformanceComponent,
        CmuNistCsfCatPerformanceComponent,
        CrrSideTocComponent,
        CmuPerformanceComponent,
        CmuNistCsfCatSummaryComponent,
        ImrReportComponent,
        ReferencesBlockComponent,
        NewAssessmentComponent,
        NewAssessmentDialogComponent,
        CrrMainTocComponent,
        CreFinalReportComponent,
        CreFinalReportGridComponent,
        CreAssessmentOverview,
        CreSubdomainChartsComponent,
        CreModelChartsComponent,
        CreMilCharts2Component,
        CreHeatmapsComponent,
        Cmmc2CommentsMarkedComponent,
        Cmmc2DeficiencyComponent,
        Cmmc2ScorecardReportComponent,
        PrivacyWarningComponent,
        PrivacyWarningRejectComponent,
        SearchPageComponent,
        LogoTsaComponent,
        OptionBlockComponent,
        DemographicsExtendedComponent,
        SectorHelpComponent,
        AnalyticsCompareComponent,
        MvraGapsComponent,
        MvraSummaryComponent,
        MvraAnswerFunctionsComponent,
        MvraAnswerDomainsComponent,
        MvraReportComponent,
        MvraSummaryPageComponent,
        MvraGapsPageComponent,
        LoginAccessKeyComponent,
        RelatedQBlockComponent,
        CpgReportComponent,
        CpgPracticeTableComponent,
        RelatedQBlockComponent,
        LogoutComponent,
        CpgDomainSummaryComponent,
        CpgCostImpactComplexityComponent,
        CpgSummaryComponent,
        CpgPracticesComponent,
        OnlineDisclaimerComponent,
        ReferencesTableComponent,
        ReferencesDisplayComponent,
        DiagramVulnerabilitiesDialogComponent,
        DiagramVulnerabilitiesComponent,
        AnalysisNetworkComponentsComponent,
        SalSectionComponent,
        AltJustificationCommentsComponent,
        QuestionCommentsComponent,
        QuestionsMarkedForReviewComponent,
        StandardsComplianceComponent,
        ComponentComplianceComponent,
        OverallComplianceComponent,
        RankedSubjectAreasComponent,
        DocumentLibraryComponent,
        ComponentQuestionListComponent,
        C2m2ReportComponent,
        C2m2CoverSheetComponent,
        C2m2IntroductionComponent,
        C2m2ModelArchitectureComponent,
        C2m2SummaryResultsComponent,
        C2m2DetailedResultsComponent,
        C2m2UsingSelfEvaluationResultsComponent,
        C2m2SelfEvaluationNotesComponent,
        C2m2ListOfPartiallyImplementedAndNotImplementedPracticesComponent,
        C2m2SideTocComponent,
        C2m2DonutComponent,
        C2m2ObjectiveTableComponent,
        CpgDomainSummaryTableComponent,
        CpgDeficiencyComponent,
        C2m2DomainMilBarChartComponent,
        PdfReportsComponent,
        InfoBlockComponent,
        SiteInformationComponent,
        LogoCyberShieldComponent,
        ExportAssessmentComponent,
        ImportPasswordComponent,
        HydroDeficiencyComponent,
        HydroDonutComponent,
        HydroBarChartComponent,
        HydroReportComponent,
        HydroSideTocComponent,
        HydroAcronymsComponent,
        HydroExecutiveSummaryComponent,
        HydroImportanceOfCybersecurityComponent,
        HydroResultsSummaryComponent,
        HydroConsequencesComponent,
        HydroImpactCategoryComponent,
        HydroFeasibilityReportComponent,
        HydroBarVerticalComponent,
        HydroImpactComponent,
        HydroFeasibilityComponent,
        HydroActionsComponent,
        HydroActionItemComponent,
        HydroProgressTotalsComponent,
        HydroActionItemsReportComponent,
        SdAnswerSummaryReportComponent,
        SdAnswerSummaryComponent,
        KeyReportComponent,
        CmuGoalPerfStackedBarComponent,
        CmuResultsDetailComponent,
        CmuNistCsfSummaryComponent,
        AssessmentConfigIodComponent,
        AssessmentDemogIodComponent,
        DemographicsIodComponent,
        TutorialImrComponent,
        ImrCoverSheetComponent,
        ImrIntroAboutComponent,
        ImrResourcesComponent,
        CmuDomainComplianceComponent,
        TsaSdComponent,
        ImrSideTocComponent,
        CmuAppendixCoverComponent,
        OtherRemarksComponent,
        CmuOtherRemarksComponent,
        UserSettingsComponent,
        MalcolmUploadErrorComponent,
        TrendAnalyticsComponent,
        PrincipleSummaryComponent,
        MalcolmAnswerDefaultComponent,
        MalcolmAnswerNestedComponent,
        MalcolmInstructionsComponent,
        AnalyticsComponent,
        SdOwnerDeficiencyComponent,
        SdOwnerCommentsMfrComponent,
        AnalyticsComponent,
        ReferencesSectionComponent,
        CisaWorkflowWarningsComponent,
        AnalyticsloginComponent,
        ReportListComponent,
        ReportListCommonComponent,
        ContactTooltipComponent,
        NoServerConnectionComponent,
        AllAnsweredquestionsComponent,
        AllCommentsmarkedComponent,
        AllReviewedComponent,
        QuestionsReviewedComponent,
        RolesChangedComponent,
        AnalyticsResultsComponent,
        UpgradeComponent,
        ImportComponent,
        AdminSettingsComponent
    ],
    bootstrap: [AppComponent], imports: [BrowserModule,
        BrowserAnimationsModule,
        FormsModule,
        CommonModule,
        AppRoutingModule,
        A11yModule,
        CdkAccordionModule,
        ClipboardModule,
        CdkStepperModule,
        CdkTableModule,
        CdkTreeModule,
        DragDropModule,
        MatAutocompleteModule,
        MatBadgeModule,
        MatBottomSheetModule,
        MatButtonModule,
        MatButtonToggleModule,
        MatCardModule,
        MatCheckboxModule,
        MatChipsModule,
        MatStepperModule,
        MatDatepickerModule,
        MatDialogModule,
        MatDividerModule,
        MatExpansionModule,
        MatGridListModule,
        MatIconModule,
        MatInputModule,
        MatListModule,
        MatMenuModule,
        MatNativeDateModule,
        MatPaginatorModule,
        MatProgressBarModule,
        MatProgressSpinnerModule,
        MatRadioModule,
        MatRippleModule,
        MatSelectModule,
        MatSidenavModule,
        MatSliderModule,
        MatSlideToggleModule,
        MatSnackBarModule,
        MatSortModule,
        MatTableModule,
        MatTabsModule,
        MatToolbarModule,
        MatTooltipModule,
        MatTreeModule,
        OverlayModule,
        PortalModule,
        ScrollingModule,
        ReactiveFormsModule,
        NgxSliderModule,
        FileUploadModule,
        AngularEditorModule,
        RouterModule,
        CurrencyMaskModule,
        TranslocoRootModule,
        NgbModule,
        NgxChartsModule,
        TooltipModule,
        EllipsisModule,
        CodeEditorModule,
        HotkeyModule.forRoot()],
    schemas: [CUSTOM_ELEMENTS_SCHEMA],
    providers: [
        TranslocoService,
        provideTranslocoScope('tutorial', 'reports'),
        ConfigService,
        AuthenticationService,
        provideAppInitializer(() => {
            const initializerFn = ((configSvc: ConfigService, authSvc: AuthenticationService, tSvc: TranslocoService) => {
                return () => {
                    return configSvc.loadConfig().then(() => {
                        // Load and set the language based on config

                        const obs = tSvc.load(configSvc.config.defaultLang);
                        const prom = firstValueFrom(obs);
                        return prom.then(() => {
                            tSvc.setActiveLang(configSvc.config.defaultLang);
                            return authSvc.checkLocal();
                        });
                    });
                };
            })(inject(ConfigService), inject(AuthenticationService), inject(TranslocoService));
            return initializerFn();
        }),
        {
            provide: HTTP_INTERCEPTORS,
            useClass: JwtInterceptor,
            multi: true
        },
        DatePipe,
        {
            provide: MAT_DATE_LOCALE,
            useFactory: (tSvc: TranslocoService) => {
                // get the language based on config
                return tSvc.getActiveLang();
            },
            deps: [TranslocoService],
            multi: true
        },
        AuthGuard,
        AssessGuard,
        AggregationGuard,
        DemographicService,
        DemographicExtendedService,
        AssessmentService,
        EmailService,
        QuestionsService,
        SalService,
        StandardService,
        FrameworkService,
        RequiredDocumentService,
        ObservationsService,
        NavigationService,
        FileUploadClientService,
        AnalysisService,
        EnableFeatureService,
        SetBuilderService,
        ResourceLibraryService,
        DiagramService,
        AggregationService,
        ChartService,
        ChartColors,
        ReportService,
        ReportAnalysisService,
        LocalStoreManager,
        CmmcStyleService,
        CmmcFilteringService,
        EdmFilteringService,
        CrrFilteringService,
        RraFilteringService,
        CmuService,
        CmuService,
        Utilities,
        GalleryService,
        FooterService,
        AnalyticsService,
        UserService,
        provideHttpClient(withInterceptorsFromDi()),
        provideCodeEditor({
            typingsWorkerUrl: 'assets/workers/typings-worker.js',
            baseUrl: 'assets/monaco'
        })
    ],
})
export class AppModule { }
