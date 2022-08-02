////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { DatePipe } from '@angular/common';
import { APP_INITIALIZER, NgModule} from '@angular/core';
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

import { FlexLayoutModule } from '@angular/flex-layout';
import {A11yModule} from '@angular/cdk/a11y';
import {CdkAccordionModule} from '@angular/cdk/accordion';
import {ClipboardModule} from '@angular/cdk/clipboard';
import {DragDropModule} from '@angular/cdk/drag-drop';
import {PortalModule} from '@angular/cdk/portal';
import {ScrollingModule} from '@angular/cdk/scrolling';
import {CdkStepperModule} from '@angular/cdk/stepper';
import {CdkTableModule} from '@angular/cdk/table';
import {CdkTreeModule} from '@angular/cdk/tree';
import {MatAutocompleteModule} from '@angular/material/autocomplete';
import {MatBadgeModule} from '@angular/material/badge';
import {MatBottomSheetModule} from '@angular/material/bottom-sheet';
import {MatButtonModule} from '@angular/material/button';
import {MatButtonToggleModule} from '@angular/material/button-toggle';
import {MatCardModule} from '@angular/material/card';
import {MatCheckboxModule} from '@angular/material/checkbox';
import {MatChipsModule} from '@angular/material/chips';
import {MatStepperModule} from '@angular/material/stepper';
import {MatDatepickerModule} from '@angular/material/datepicker';
import {MatDialogModule} from '@angular/material/dialog';
import {MatDividerModule} from '@angular/material/divider';
import {MatExpansionModule} from '@angular/material/expansion';
import {MatGridListModule} from '@angular/material/grid-list';
import {MatIconModule} from '@angular/material/icon';
import {MatInputModule} from '@angular/material/input';
import {MatListModule} from '@angular/material/list';
import {MatMenuModule} from '@angular/material/menu';
import {MatNativeDateModule, MatRippleModule} from '@angular/material/core';
import {MatPaginatorModule} from '@angular/material/paginator';
import {MatProgressBarModule} from '@angular/material/progress-bar';
import {MatProgressSpinnerModule} from '@angular/material/progress-spinner';
import {MatRadioModule} from '@angular/material/radio';
import {MatSelectModule} from '@angular/material/select';
import {MatSidenavModule} from '@angular/material/sidenav';
import {MatSliderModule} from '@angular/material/slider';
import {MatSlideToggleModule} from '@angular/material/slide-toggle';
import {MatSnackBarModule} from '@angular/material/snack-bar';
import {MatSortModule} from '@angular/material/sort';
import {MatTableModule} from '@angular/material/table';
import {MatTabsModule} from '@angular/material/tabs';
import {MatToolbarModule} from '@angular/material/toolbar';
import {MatTooltipModule} from '@angular/material/tooltip';
import {MatTreeModule} from '@angular/material/tree';
import {OverlayModule} from '@angular/cdk/overlay';

import {AutosizeModule} from 'ngx-autosize';

import { NgxSliderModule } from '@angular-slider/ngx-slider';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HotkeyModule } from 'angular2-hotkeys';
import { TextareaAutosizeModule } from 'ngx-textarea-autosize';
import { FileUploadModule } from 'ng2-file-upload';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { AssessmentComponent } from './assessment/assessment.component';
import { StatusCreateComponent } from './assessment/documents/status-create/status-create.component';
import { AssessmentContactsComponent } from './assessment/prepare/assessment-info/assessment-contacts/assessment-contacts.component';
import { ContactItemComponent } from './assessment/prepare/assessment-info/assessment-contacts/contact-item/contact-item.component';
// tslint:disable-next-line:max-line-length
import { AssessmentDemographicsComponent } from './assessment/prepare/assessment-info/assessment-demographics/assessment-demographics.component';
import { AssessmentDetailComponent } from './assessment/prepare/assessment-info/assessment-detail/assessment-detail.component';
import { AssessmentInfoComponent } from './assessment/prepare/assessment-info/assessment-info.component';
import { Assessment2InfoComponent } from './assessment/prepare/assessment-info/assessment2-info/assessment2-info.component';
import { AssessmentInfoTsaComponent } from './assessment/prepare/assessment-info/assessment-info-tsa/assessment-info-tsa.component';
import { AssessmentConfigComponent } from './assessment/prepare/assessment-info/assessment-config/assessment-config.component';
import { FrameworkComponent } from './assessment/prepare/framework/framework.component';
import { RequiredDocsComponent } from './assessment/prepare/required/required.component';
import { IRPComponent } from './assessment/prepare/irp/irp.component';
import { PrepareComponent } from './assessment/prepare/prepare.component';
import { SalGenComponent } from './assessment/prepare/sals/sal-gen/sal-gen.component';
import { SalNistComponent } from './assessment/prepare/sals/sal-nist/sal-nist.component';
import { SalSimpleComponent } from './assessment/prepare/sals/sal-simple/sal-simple.component';
import { SalsComponent } from './assessment/prepare/sals/sals.component';
import { StandardsComponent } from './assessment/prepare/standards/standards.component';
import { FindingsComponent } from './assessment/questions/findings/findings.component';
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
import { TermsOfUseComponent } from './dialogs/terms-of-use/terms-of-use.component';
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
import { NullishCoalescePipe } from './helpers/nullish-coalesce.pipe';
import { ImportComponent } from './import/import.component';
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
import { FindingsService } from './services/findings.service';
import { FrameworkService } from './services/framework.service';
import { NavigationService } from './services/navigation.service';
import { QuestionsService } from './services/questions.service';
import { SalService } from './services/sal.service';
import { StandardService } from './services/standard.service';
import { CodeEditorModule } from '@ngstack/code-editor';
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
import { IRPService } from './services/irp.service';
import { MatDetailComponent } from './assessment/results/mat-detail/mat-detail.component';
import { ACETDashboardComponent } from './assessment/results/dashboard/acet-dashboard.component';
import { AdminComponent } from './assessment/results/admin/admin.component';
import { ACETService } from './services/acet.service';
import { CurrencyMaskModule } from 'ng2-currency-mask';
import { DomainMaturityFilterComponent } from './assessment/questions/domain-maturity-filter/domain-maturity-filter.component';
import { ResourceLibraryService } from './services/resource-library.service';
import { IrpSummaryComponent } from './assessment/prepare/irp-summary/irp-summary.component';
import { DiagramComponent } from './assessment/diagram/diagram.component';
import { DiagramInfoComponent } from './assessment/diagram/diagram-info/diagram-info.component';
import { DiagramInventoryComponent } from './assessment/diagram/diagram-inventory/diagram-inventory.component';
import { ComponentsComponent } from './assessment/diagram/diagram-inventory/components/components.component';
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
import { CompareSummaryComponent } from './aggregation/compare-analytics/compare-summary/compare-summary.component';
import { CompareMissedComponent } from './aggregation/compare-analytics/compare-missed/compare-missed.component';
import { CompareIndividualComponent } from './aggregation/compare-analytics/compare-individual/compare-individual.component';
import { CompareBestworstComponent } from './aggregation/compare-analytics/compare-bestworst/compare-bestworst.component';
import { SelectAssessmentsComponent } from './dialogs/select-assessments/select-assessments.component';
import { ChartService } from './services/chart.service';
import { ChartColors } from './services/chart.service';
import { AnalyticsComponent } from './assessment/results/analytics/analytics.component';
import { AnalyticsService } from './services/analytics.service';
import { DataloginComponent } from './assessment/results/analysis/submitdata/datalogin/datalogin.component';
import { LayoutBlankComponent } from './layout/layout-blank/layout-blank.component';
import { LayoutMainComponent } from './layout/layout-main/layout-main.component';
import { AcetLayoutMainComponent } from './layout/acet-layout-main/acet-layout-main.component';
import { TsaLayoutMainComponent } from './layout/tsa-layout-main/tsa-layout-main.component';
import { RraLayoutMainComponent } from './layout/rra-layout-main/rra-layout-main.component';
import { ReportTestComponent } from './reports/report-test/report-test.component';
import { DetailComponent } from './reports/detail/detail.component';
import { DiscoveryTearoutsComponent } from './reports/discovery-tearouts/discovery-tearouts.component';
import { EvalAgainstComponent } from './reports/eval-against/eval-against.component';
import { ExecutiveComponent } from './reports/executive/executive.component';
import { SecurityplanComponent } from './reports/securityplan/securityplan.component';
import { SitesummaryComponent } from './reports/sitesummary/sitesummary.component';
import { ReportService } from './services/report.service';
import { ReportAnalysisService } from './services/report-analysis.service';
import { LocalStoreManager } from './services/storage.service';
import { TrendReportComponent } from './reports/trendreport/trendreport.component';
import { CompareReportComponent } from './reports/comparereport/comparereport.component';
import { AwwaStandardComponent } from './assessment/prepare/standards/awwa-standard/awwa-standard.component';
import { ModelSelectComponent } from './assessment/prepare/maturity/model-select/model-select.component';
import { CmmcLevelsComponent } from './assessment/prepare/maturity/cmmc-levels/cmmc-levels.component';
import { CmmcAComponent } from './assessment/prepare/maturity/cmmc-a/cmmc-a.component';
import { CategoryBlockComponent } from './assessment/questions/category-block/category-block.component';
import { MaturityQuestionsComponent } from './assessment/questions/maturity-questions/maturity-questions.component';
import { AskQuestionsComponent } from './assessment/questions/ask-questions/ask-questions.component';
import { DiagramQuestionsComponent } from './assessment/questions/diagram-questions/diagram-questions.component';
import { ExecutiveCMMCComponent } from './reports/cmmc/executive-cmmc/executive-cmmc.component';
import { SitesummaryCMMCComponent } from './reports/cmmc/sitesummary-cmmc/sitesummary-cmmc.component';
import { CmmcLevelResultsComponent } from './assessment/results/mat-cmmc/cmmc-level-results/cmmc-level-results.component';
import { CmmcLevelDrilldownComponent } from './assessment/results/mat-cmmc/cmmc-level-drilldown/cmmc-level-drilldown.component';
import { CmmcComplianceComponent } from './assessment/results/mat-cmmc/cmmc-compliance/cmmc-compliance.component';
import { CmmcGapsComponent } from './assessment/results/mat-cmmc/cmmc-gaps/cmmc-gaps.component';
import { Cmmc2LevelResultsComponent } from './assessment/results/mat-cmmc2/cmmc2-level-results/cmmc2-level-results.component';
import { Cmmc2DomainResultsComponent } from './assessment/results/mat-cmmc2/cmmc2-domain-results/cmmc2-domain-results.component';
import { ExecutiveCMMC2Component } from './reports/cmmc2/executive-cmmc2/executive-cmmc2.component';
import { CommonModule } from '@angular/common';
import { NavBackNextComponent } from './assessment/navigation/nav-back-next/nav-back-next.component';
import { CsetOriginComponent } from './initial/cset-origin/cset-origin.component';
import { ComplianceScoreComponent } from './assessment/results/mat-cmmc/chart-components/compliance-score/compliance-score.component';
import { CmmcStyleService } from './services/cmmc-style.service';
import { InherentRiskProfileComponent } from './acet/inherent-risk-profile/inherent-risk-profile.component';
import { IrpSectionComponent } from './reports/irp/irp.component';
import { ChartsDonutComponent } from './reports/charts-donut/charts-donut.component';
import { AcetExecutiveComponent } from './reports/acet-executive/acet-executive.component';
import { AcetDeficencyComponent } from './reports/acet-deficency/acet-deficency.component';
import { AcetCommentsmarkedComponent } from './reports/acet-commentsmarked/acet-commentsmarked.component';
import { AcetAnsweredQuestionsComponent } from './reports/acet-answeredquestions/acet-answeredquestions.component';
import { AcetCompensatingcontrolsComponent } from './reports/acet-compensatingcontrols/acet-compensatingcontrols.component';
import { TutorialCmmcComponent } from './assessment/prepare/maturity/tutorial-cmmc/tutorial-cmmc.component';
import { TutorialEdmComponent } from './assessment/prepare/maturity/tutorial-edm/tutorial-edm.component';
import { LoginAcetComponent } from './initial/login-acet/login-acet.component';
import { LoginCsetComponent } from './initial/login-cset/login-cset.component';
import { AboutCsetComponent } from './dialogs/about-cset/about-cset.component';
import { AboutAcetComponent } from './dialogs/about-acet/about-acet.component';
import { AcetOriginComponent } from './initial/acet-origin/acet-origin.component';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import { GroupingBlockComponent } from './assessment/questions/grouping-block/grouping-block.component';
import { QuestionBlockMaturityComponent } from './assessment/questions/question-block-maturity/question-block-maturity.component';
import { EdmDeficiencyComponent } from './reports/edm-deficiency/edm-deficiency.component';
import { EdmCommentsmarkedComponent } from './reports/edm-commentsmarked/edm-commentsmarked.component';
import { CisCommentsmarkedComponent } from './reports/cis-commentsmarked/cis-commentsmarked.component';
import { MaturityQuestionsAcetComponent } from './assessment/questions/maturity-questions/maturity-questions-acet.component';
import { MaturityQuestionsIseComponent } from './assessment/questions/maturity-questions/maturity-questions-ise.component';
import { EdmComponent } from './reports/edm/edm.component';
import { TooltipModule } from 'ng2-tooltip-directive';
import { QuestionTextComponent } from './assessment/questions/question-text/question-text.component';
import { AcetFilteringService } from './services/filtering/maturity-filtering/acet-filtering.service';
import { CmmcFilteringService } from './services/filtering/maturity-filtering/cmmc-filtering.service';
import { EdmFilteringService } from './services/filtering/maturity-filtering/edm-filtering.service';
import { CrrFilteringService } from './services/filtering/maturity-filtering/crr-filtering.service';
import { RraFilteringService } from './services/filtering/maturity-filtering/rra-filtering.service';
import { GlossaryTermComponent } from './assessment/questions/question-text/glossary-term/glossary-term.component';
import { PlaceholderQuestionsComponent } from './assessment/questions/placeholder-questions/placeholder-questions.component';
import { FeatureOptionComponent } from './assessment/prepare/assessment-info/assessment-config/feature-option/feature-option.component';
import { EdmRelationshipComponent } from './assessment/results/edm/edm-relationship/edm-relationship.component';
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
import { EDMHorizontalBarChart } from './reports/edm/horizontal-bar-chart/horizontal-bar-chart.component'
import { EDMTripleBarChart } from './reports/edm/triple-bar-chart/triple-bar-chart.component'
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
import { CrrExecutiveComponent } from './reports/crr/crr-executive/crr-executive.component';
import { TutorialRraComponent } from './assessment/prepare/maturity/tutorial-rra/tutorial-rra.component';
import { RraLevelResultsComponent } from './assessment/results/mat-rra/rra-level-results/rra-level-results.component';
import { RraGapsComponent } from './assessment/results/mat-rra/rra-gaps/rra-gaps.component';
import { RraDeficiencyComponent } from './reports/rra/rra-deficiency/rra-deficiency.component';
import { RraReportComponent } from './reports/rra/rra-report/rra-report.component';
import { CommentsMfrComponent } from './reports/commentsmfr/commentsmfr.component';
import { RraSummaryComponent } from './assessment/results/mat-rra/rra-summary/rra-summary.component';
import { RraSummaryAllComponent } from './assessment/results/mat-rra/rra-summary-all/rra-summary-all.component';
import { ReportDisclaimerComponent } from './reports/general/report-disclaimer/report-disclaimer.component';
import { ReportAdvisoryComponent } from './reports/general/report-advisory/report-advisory.component';
import { RraLevelsComponent } from './assessment/results/mat-rra/rra-levels/rra-levels.component';
import { RraAnswerCountsComponent } from './assessment/results/mat-rra/rra-answer-counts/rra-answer-counts.component';
import { RraAnswerDistributionComponent } from './assessment/results/mat-rra/rra-answer-distribution/rra-answer-distribution.component';
import { RraAnswerComplianceComponent } from './assessment/results/mat-rra/rra-answer-compliance/rra-answer-compliance.component';
import { RraQuestionsScoringComponent } from './assessment/results/mat-rra/rra-questions-scoring/rra-questions-scoring.component';
import { RraMiniUserGuideComponent } from './dialogs/rra-mini-user-guide/rra-mini-user-guide.component';
import { IrpTabsComponent } from './assessment/prepare/irp/irp-tabs/irp-tabs.component';
import { CrrSummaryResultsComponent } from './assessment/results/crr/crr-summary-results/crr-summary-results.component';
import { CrrResultsPage } from './assessment/results/crr/crr-results-page/crr-results-page.component';
import { CrrResultsDetailComponent } from './assessment/results/crr/crr-results-detail/crr-results-detail.component';
import { CrrHeatmapComponent } from './assessment/results/crr/crr-heatmap/crr-heatmap.component';
import { CrrService } from './services/crr.service';
import { Utilities } from './services/utilities.service';
import { NCUAService } from './services/ncua.service';

import { RunScriptsDirective } from './helpers/run-scripts.directive';
import { MatCommentsComponent } from './reports/edm/mat-comments/mat-comments.component';
import { TsaAssessmentCompleteComponent } from './assessment/results/tsa-assessment-complete/tsa-assessment-complete.component';
import { LoginTsaComponent } from './initial/login-tsa/login-tsa.component';
import { FeatureOptionTsaComponent } from './assessment/prepare/assessment-info/assessment-config-tsa/feature-option-tsa/feature-option-tsa.component';
import { AboutTsaComponent } from './dialogs/about-tsa/about-tsa.component';
import { SprsScoreComponent } from './assessment/results/mat-cmmc2/sprs-score/sprs-score.component';
import { AssessmentConfigTsaComponent } from './assessment/prepare/assessment-info/assessment-config-tsa/assessment-config-tsa.component';
import { TutorialCmmc2Component } from './assessment/prepare/maturity/tutorial-cmmc2/tutorial-cmmc2.component';
import { TopMenusComponent } from './layout/top-menus/top-menus.component';
import { LoginRraComponent } from './initial/login-rra/login-rra.component';
import { AboutRraComponent } from './dialogs/about-rra/about-rra.component';
import { LogoRraComponent } from './layout/logos/logo-rra/logo-rra.component';
import { LogoCsetComponent } from './layout/logos/logo-cset/logo-cset.component';
import { LogoForReportsComponent } from './reports/logo-for-reports/logo-for-reports.component';
import { QuestionBlockVadrComponent } from './assessment/questions/question-block-vadr/question-block-vadr.component';
import { VadrDeficiencyComponent } from './reports/vadr/vadr-deficiency/vadr-deficiency.component';
import { CsiComponent } from './assessment/prepare/csi/csi.component';
import { CsiOrganizationDemographicsComponent } from './assessment/prepare/csi/csi-organization-demographics/csi-organization-demographics.component';
import { CsiServiceDemographicsComponent } from './assessment/prepare/csi/csi-service-demographics/csi-service-demographics.component';
import { CsiServiceCompositionComponent } from './assessment/prepare/csi/csi-service-composition/csi-service-composition.component';
import { AssessmentInfo2TsaComponent } from './assessment/prepare/assessment-info/assessment-info2-tsa/assessment-info2-tsa.component';
import { AssessmentDemographicsTsaComponent } from './assessment/prepare/assessment-info/assessment-demographics-tsa/assessment-demographics-tsa.component';
import { TsaAnalyticsComponent } from './initial/tsa-analytics/tsa-analytics.component';
import { MaturityQuestionsNestedComponent } from './assessment/questions/maturity-questions/nested/maturity-questions-nested/maturity-questions-nested.component';
import { QuestionBlockNestedComponent } from './assessment/questions/maturity-questions/nested/question-block-nested/question-block-nested.component';
import { GroupingBlockNestedComponent } from './assessment/questions/maturity-questions/nested/grouping-block-nested/grouping-block-nested.component';
import { OptionBlockNestedComponent } from './assessment/questions/maturity-questions/nested/option-block-nested/option-block-nested.component';
import { ModuleContentLaunchComponent } from './reports/module-content/module-content-launch/module-content-launch.component';
import { ModuleContentComponent } from './reports/module-content/module-content/module-content.component';
import { TutorialCisComponent } from './assessment/prepare/maturity/tutorial-cis/tutorial-cis.component';
import { AssessmentDetailNcuaComponent } from './assessment/prepare/assessment-info/assessment-detail-ncua/assessment-detail-ncua.component';
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
import { AssessmentConfigNcuaComponent } from './assessment/prepare/assessment-info/assessment-config-ncua/assessment-config-ncua.component';
import { FeatureOptionNcuaComponent } from './assessment/prepare/assessment-info/assessment-config-ncua/feature-option-ncua/feature-option-ncua.component';
import { CoverSheetAComponent } from './reports/cis/shared/cover-sheet-a/cover-sheet-a.component';
import { DisclaimerBlurbAComponent } from './reports/cis/shared/disclaimer-blurb-a/disclaimer-blurb-a.component';
import { ConfigCisComponent } from './assessment/prepare/maturity/config-cis/config-cis.component';
import { CisRankedDeficiencyComponent } from './reports/cis/cis-ranked-deficiency/cis-ranked-deficiency.component';
import { RankedDeficienctyChartComponent } from './assessment/results/cis/ranked-deficiencty-chart/ranked-deficiencty-chart.component';
import { RankedDeficiencyComponent } from './assessment/results/cis/ranked-deficiency/ranked-deficiency.component';
import { CisSectionScoringComponent } from './reports/cis/cis-section-scoring/cis-section-scoring.component';
import { CisScoringChartComponent } from './reports/cis/cis-section-scoring/cis-scoring-chart/cis-scoring-chart.component';
import { SectionScoringComponent } from './assessment/results/cis/section-scoring/section-scoring.component';
import { MergeExaminationsComponent } from './assessment/merge/merge-examinations.component';
import { CharterMismatchComponent } from './dialogs/charter-mistmatch/charter-mismatch.component';
import { DigitsOnlyNotZeroDirective } from './helpers/digits-only-not-zero.directive';
import { LandingPageTabsComponent } from './initial/landing-page-tabs/landing-page-tabs.component';
import { NewAssessmentComponent } from './initial/new-assessment/new-assessment.component';
import { ModuleContentStandardComponent } from './reports/module-content/module-content-standard/module-content-standard.component';
import { ModuleContentModelComponent } from './reports/module-content/model/module-content-model/module-content-model.component';
import { McGroupingComponent } from './reports/module-content/model/mc-grouping/mc-grouping.component';
import { McQuestionComponent } from './reports/module-content/model/mc-question/mc-question.component';
import { McOptionComponent } from './reports/module-content/model/mc-option/mc-option.component';
import { GuidanceBlockComponent } from './reports/module-content/guidance-block/guidance-block.component';
import { ReferencesBlockComponent } from './reports/module-content/references-block/references-block.component';


@NgModule({
    imports: [
        BrowserModule,
        BrowserAnimationsModule,
        FormsModule,
        HttpClientModule,
        CommonModule,
        AppRoutingModule,

        // Material
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
        AutosizeModule,
        // NgChartsModule,
        // MatButtonModule,
        // MatToolbarModule,
        // MatChipsModule,
        // MatSlideToggleModule,
        // MatInputModule,
        // MatCardModule,
        // MatSliderModule,
        // MatDatepickerModule,
        // MatNativeDateModule,
        // MatFormFieldModule,
        // MatSortModule,
        // MatExpansionModule,
        // MatAutocompleteModule,
        // MatDialogModule,
        // MatTooltipModule,
        // MatSnackBarModule,
        // MatSidenavModule,
        // MatTreeModule,
        // MatIconModule,
        // MatDividerModule,
        // MatProgressSpinnerModule,
        // MatProgressBarModule,
        // MatListModule,
        // MatMenuModule,
        // MatTabsModule,

        FlexLayoutModule,
        ReactiveFormsModule,
        NgxSliderModule,
        TextareaAutosizeModule,
        FileUploadModule,
        AngularEditorModule,
        RouterModule,
        CurrencyMaskModule,
        NgbModule,
        NgxChartsModule,
        TooltipModule,
        HotkeyModule.forRoot(),
        CodeEditorModule.forRoot({
            typingsWorkerUrl: 'assets/workers/typings-worker.js',
            baseUrl: 'assets/monaco'
        }),
    ],
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
        AssessmentDetailNcuaComponent,
        ResultsComponent,
        SalSimpleComponent,
        StandardsComponent,
        ResetPassComponent,
        EmailComponent,
        ConfirmEqualValidatorDirective,
        EmailValidatorDirective,
        FocusDirective,
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
        IRPComponent,
        DiagramComponent,
        MatDetailComponent,
        AboutComponent,
        AdvisoryComponent,
        QuestionsComponent,
        QuestionBlockComponent,
        QuestionExtrasComponent,
        ResourceLibraryComponent,
        OkayComponent,
        FindingsComponent,
        SafePipe,
        LinebreakPipe,
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
        QuestionFiltersComponent,
        AssessmentDocumentsComponent,
        InlineParameterComponent,
        GlobalParametersComponent,
        ImportComponent,
        UploadExportComponent,
        KeyboardShortcutsComponent,
        LicenseComponent,
        ACETDashboardComponent,
        AdminComponent,
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
        DomainMaturityFilterComponent,
        IrpSummaryComponent,
        DiagramInventoryComponent,
        DiagramInfoComponent,
        ComponentsComponent,
        LinksComponent,
        NetworkWarningsComponent,
        ShapesComponent,
        TextComponent,
        ZonesComponent,
        ComponentOverrideComponent,
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
        ComponentOverrideComponent,
        ExcelExportComponent,
        AnalyticsComponent,
        DataloginComponent,
        LayoutBlankComponent,
        LayoutMainComponent,
        AcetLayoutMainComponent,
        ReportTestComponent,
        DetailComponent,
        DiscoveryTearoutsComponent,
        EvalAgainstComponent,
        ExecutiveComponent,
        SecurityplanComponent,
        SitesummaryComponent,
        TrendReportComponent,
        CompareReportComponent,
        Assessment2InfoComponent,
        ModelSelectComponent,
        AssessmentConfigComponent,
        CmmcAComponent,
        CmmcLevelsComponent,
        CmmcLevelResultsComponent,
        CmmcLevelDrilldownComponent,
        CmmcComplianceComponent,
        CmmcGapsComponent,
        Cmmc2LevelResultsComponent,
        Cmmc2DomainResultsComponent,
        SprsScoreComponent,
        ComplianceScoreComponent,
        ModelSelectComponent,
        CategoryBlockComponent,
        AskQuestionsComponent,
        MaturityQuestionsComponent,
        MaturityQuestionsAcetComponent,
        MaturityQuestionsIseComponent,
        AwwaStandardComponent,
        DiagramQuestionsComponent,
        SitesummaryCMMCComponent,
        ExecutiveCMMCComponent,
        ExecutiveCMMC2Component,
        NavBackNextComponent,
        CsetOriginComponent,
        InherentRiskProfileComponent,
        IrpSectionComponent,
        ChartsDonutComponent,
        AcetExecutiveComponent,
        AcetDeficencyComponent,
        AcetCommentsmarkedComponent,
        AcetAnsweredQuestionsComponent,
        AcetCompensatingcontrolsComponent,
        TutorialCmmcComponent,
        TutorialEdmComponent,
        TutorialRraComponent,
        TutorialCrrComponent,
        LoginAcetComponent,
        LoginCsetComponent,
        LoginRraComponent,
        AboutCsetComponent,
        AboutAcetComponent,
        AcetOriginComponent,
        GroupingBlockComponent,
        QuestionBlockMaturityComponent,
        EdmComponent,
        EdmDeficiencyComponent,
        EdmCommentsmarkedComponent,
        CisCommentsmarkedComponent,
        QuestionTextComponent,
        GlossaryTermComponent,
        PlaceholderQuestionsComponent,
        FeatureOptionComponent,
        EdmRelationshipComponent,
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
        CrrExecutiveComponent,
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
        IrpTabsComponent,
        CrrSummaryResultsComponent,
        CrrResultsPage,
        CrrResultsDetailComponent,
        CrrHeatmapComponent,
        MatCommentsComponent,
        AssessmentInfoTsaComponent,
        TsaLayoutMainComponent,
        TsaAssessmentCompleteComponent,
        LoginTsaComponent,
        AssessmentConfigTsaComponent,
        FeatureOptionTsaComponent,
        AboutTsaComponent,
        TutorialCmmc2Component,
        TopMenusComponent,
        RraLayoutMainComponent,
        AboutRraComponent,
        LogoRraComponent,
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
        AssessmentInfo2TsaComponent,
        AssessmentDemographicsTsaComponent,
        TsaAnalyticsComponent,
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
        OpenEndedQuestionsComponent,
        CisSurveyComponent,
        GroupingBlockNestedReportComponent,
        QuestionBlockNestedReportComponent,
        OptionBlockNestedReportComponent,
        AssessmentConfigNcuaComponent,
        FeatureOptionNcuaComponent,
        CoverSheetAComponent,
        DisclaimerBlurbAComponent,
        ConfigCisComponent,
        CisRankedDeficiencyComponent,
        RankedDeficienctyChartComponent,
        CisCommentsmarkedComponent,
        RankedDeficiencyComponent,
        CisSectionScoringComponent,
        CisScoringChartComponent,
        SectionScoringComponent,
        MergeExaminationsComponent,
        CharterMismatchComponent,
        DigitsOnlyNotZeroDirective,
        LandingPageTabsComponent,
        NewAssessmentComponent,
        ModuleContentStandardComponent,
        ModuleContentModelComponent,
        McGroupingComponent,
        McQuestionComponent,
        McOptionComponent,
        GuidanceBlockComponent,
        ReferencesBlockComponent
    ],
    providers: [
        ConfigService,
        AuthenticationService,
        {
          provide: APP_INITIALIZER,
          useFactory: (configSvc: ConfigService, authSvc: AuthenticationService) => {
            return () => {
              return configSvc.loadConfig().then(() => {
                return authSvc.checkLocal();
              });
            };
          },
          deps: [ConfigService, AuthenticationService],
          multi: true
        },
        {
            provide: HTTP_INTERCEPTORS,
            useClass: JwtInterceptor,
            multi: true
        },
        DatePipe,
        AuthGuard,
        AssessGuard,
        AggregationGuard,
        DemographicService,
        AssessmentService,
        EmailService,
        QuestionsService,
        SalService,
        StandardService,
        FrameworkService,
        RequiredDocumentService,
        IRPService,
        FindingsService,
        NavigationService,
        FileUploadClientService,
        AnalysisService,
        EnableFeatureService,
        SetBuilderService,
        ACETService,
        ResourceLibraryService,
        DiagramService,
        AnalyticsService,
        AggregationService,
        ChartService,
        ChartColors,
        ReportService,
        ReportAnalysisService,
        LocalStoreManager,
        CmmcStyleService,
        AcetFilteringService,
        CmmcFilteringService,
        EdmFilteringService,
        CrrFilteringService,
        RraFilteringService,
        CrrService,
        Utilities,
        NCUAService,
    ],
    bootstrap: [AppComponent],
    entryComponents: [
        EmailComponent,
        EditUserComponent,
        EjectionComponent,
        AlertComponent,
        ConfirmComponent,
        ChangePasswordComponent,
        AboutComponent,
        AdvisoryComponent,
        OkayComponent,
        TermsOfUseComponent,
        FindingsComponent,
        EnableProtectedComponent,
        QuestionFiltersComponent,
        AssessmentDocumentsComponent,
        UploadExportComponent,
        InlineParameterComponent,
        GlobalParametersComponent,
        KeyboardShortcutsComponent,
        LicenseComponent,
        AddRequirementComponent,
        ComponentOverrideComponent,
        ExcelExportComponent,
        MergeQuestionDetailComponent,
        SelectAssessmentsComponent,
        DataloginComponent,
        AwwaStandardComponent
    ]
})

export class AppModule { }
