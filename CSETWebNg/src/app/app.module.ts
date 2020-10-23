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
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { APP_INITIALIZER, NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatNativeDateModule } from '@angular/material/core';
import { MatDialogModule } from '@angular/material/dialog';
import { MatDividerModule } from '@angular/material/divider';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatListModule } from '@angular/material/list';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { MatTabsModule } from '@angular/material/tabs';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatTreeModule } from '@angular/material/tree';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSortModule } from '@angular/material/sort';
import { MatExpansionModule } from '@angular/material/expansion';
import { MatSliderModule } from '@angular/material/slider';
import { Ng5SliderModule } from 'ng5-slider';
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
import { LandingPageComponent } from './initial/landing-page/landing-page.component';
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
import { MaturityFilterComponent } from './assessment/questions/maturity-filter/maturity-filter.component';
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
import { AggregationChartService } from './services/aggregation-chart.service';
import { ChartColors } from './services/aggregation-chart.service';
import { AnalyticsComponent } from './assessment/results/analytics/analytics.component';
import { AnalyticsService } from './services/analytics.service';
import { DataloginComponent } from './assessment/results/analysis/submitdata/datalogin/datalogin.component';
import { LayoutBlankComponent } from './layout/layoutblank/layout-blank.component';
import { LayoutMainComponent } from './layout/layoutmain/layout-main.component';
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
import { DomainBlockComponent } from './assessment/questions/domain-block/domain-block.component';
import { MaturityQuestionsComponent } from './assessment/questions/maturity-questions/maturity-questions.component';
import { AskQuestionsComponent } from './assessment/questions/ask-questions/ask-questions.component';
import { DiagramQuestionsComponent } from './assessment/questions/diagram-questions/diagram-questions.component';
import { ExecutiveCMMCComponent } from './reports/executive-cmmc/executive-cmmc.component';
import { SitesummaryCMMCComponent } from './reports/sitesummary-cmmc/sitesummary-cmmc.component';
import { CmmcLevelResultsComponent } from './assessment/results/mat-cmmc/cmmc-level-results/cmmc-level-results.component';
import { CmmcLevelDrilldownComponent } from './assessment/results/mat-cmmc/cmmc-level-drilldown/cmmc-level-drilldown.component';
import { CmmcComplianceComponent } from './assessment/results/mat-cmmc/cmmc-compliance/cmmc-compliance.component';
import { CmmcGapsComponent } from './assessment/results/mat-cmmc/cmmc-gaps/cmmc-gaps.component';
import { CommonModule } from '@angular/common';

@NgModule({
    imports: [
        BrowserModule,
        BrowserAnimationsModule,
        FormsModule,
        HttpClientModule,
        CommonModule,
        AppRoutingModule,
        MatInputModule,
        MatSliderModule,
        MatDatepickerModule,
        MatNativeDateModule,
        MatFormFieldModule,
        MatSortModule,
        MatExpansionModule,
        MatAutocompleteModule,
        ReactiveFormsModule,
        MatDialogModule,
        MatTooltipModule,
        MatSnackBarModule,
        Ng5SliderModule,
        MatSidenavModule,
        TextareaAutosizeModule,
        MatTreeModule,
        MatIconModule,
        MatDividerModule,
        MatProgressSpinnerModule,
        MatProgressBarModule,
        MatListModule,
        FileUploadModule,
        AngularEditorModule,
        RouterModule,
        CurrencyMaskModule,
        NgbModule,
        MatTabsModule,
        HotkeyModule.forRoot(),
        CodeEditorModule.forRoot({
            typingsWorkerUrl: 'assets/workers/typings-worker.js',
            baseUrl: 'assets/monaco'
        })
    ],
    declarations: [
        AppComponent,
        InitialComponent,
        LoginComponent,
        LandingPageComponent,
        AssessmentComponent,
        PrepareComponent,
        AssessmentInfoComponent,
        AssessmentDetailComponent,
        AssessmentContactsComponent,
        AssessmentDemographicsComponent,
        ContactItemComponent,
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
        MaturityFilterComponent,
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
        AssessmentConfigComponent,
        ModelSelectComponent,
        CategoryBlockComponent,
        AskQuestionsComponent,
        MaturityQuestionsComponent,
        DomainBlockComponent,
        AwwaStandardComponent,
        DiagramQuestionsComponent,
        SitesummaryCMMCComponent,
        ExecutiveCMMCComponent,
    ],
    providers: [
        ConfigService,
        {
            provide: APP_INITIALIZER,
            useFactory: (configSvc: ConfigService) => () => configSvc.loadConfig(),
            deps: [ConfigService],
            multi: true
        },
        AuthenticationService,
        {
            provide: HTTP_INTERCEPTORS,
            useClass: JwtInterceptor,
            multi: true
        },
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
        AggregationChartService,
        ChartColors, 
        ReportService,
        ReportAnalysisService, 
        LocalStoreManager
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
