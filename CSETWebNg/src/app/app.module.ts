////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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
import { MatAutocompleteModule, MatDialogModule, MatDividerModule,
  MatIconModule, MatInputModule, MatListModule, MatNativeDateModule,
  MatProgressBarModule, MatProgressSpinnerModule, MatSidenavModule,
  MatTooltipModule, MatTreeModule } from '@angular/material';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSortModule } from '@angular/material/sort';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HotkeyModule } from 'angular2-hotkeys';
import { IonRangeSliderModule } from 'ng2-ion-range-slider';
import { TextareaAutosizeModule } from 'ngx-textarea-autosize';
import { FileUploadModule } from '../../node_modules/ng2-file-upload/ng2-file-upload';
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
import { FrameworkComponent } from './assessment/prepare/framework/framework.component';
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
// tslint:disable-next-line:max-line-length
import { OverallRankedCategoriesComponent } from './assessment/results/analysis/overall-ranked-categories/overall-ranked-categories.component';
import { RankedQuestionsComponent } from './assessment/results/analysis/ranked-questions/ranked-questions.component';
import { StandardsRankedComponent } from './assessment/results/analysis/standards-ranked/standards-ranked.component';
import { StandardsResultsComponent } from './assessment/results/analysis/standards-results/standards-results.component';
import { StandardsSummaryComponent } from './assessment/results/analysis/standards-summary/standards-summary.component';
import { OverviewComponent } from './assessment/results/overview/overview.component';
import { ReportsComponent } from './assessment/results/reports/reports.component';
import { ResultsComponent } from './assessment/results/results.component';
import { AboutComponent } from './dialogs/about/about.component';
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
import { ConfirmEqualValidatorDirective } from './helpers/confirm-equal-validator.directive';
import { EmailValidatorDirective } from './helpers/email-validator.directive';
import { FocusDirective } from './helpers/focus.directive';
import { InViewComponent } from './helpers/in-view/in-view.component';
import { JwtInterceptor } from './helpers/jwt.interceptor';
import { ProgressComponent } from './helpers/progress/progress.component';
import { SafePipe } from './helpers/safe.pipe';
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
import { UserInfoComponent } from './user-info/user-info.component';
import { CodeEditorModule } from '@ngstack/code-editor';

@NgModule({
    imports: [
        BrowserModule,
        BrowserAnimationsModule,
        FormsModule,
        HttpClientModule,
        AppRoutingModule,
        MatInputModule,
        MatDatepickerModule,
        MatNativeDateModule,
        MatFormFieldModule,
        MatSortModule,
        MatAutocompleteModule,
        ReactiveFormsModule,
        MatDialogModule,
        MatTooltipModule,
        IonRangeSliderModule,
        MatSidenavModule,
        TextareaAutosizeModule,
        MatTreeModule,
        MatIconModule,
        MatDividerModule,
        MatProgressSpinnerModule,
        MatProgressBarModule,
        MatListModule,
        FileUploadModule,
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
        UserInfoComponent,
        EmailComponent,
        ConfirmEqualValidatorDirective,
        EmailValidatorDirective,
        FocusDirective,
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
        AboutComponent,
        AdvisoryComponent,
        QuestionsComponent,
        QuestionBlockComponent,
        QuestionExtrasComponent,
        ResourceLibraryComponent,
        OkayComponent,
        FindingsComponent,
        SafePipe,
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
        OverallRankedCategoriesComponent,
        EnableProtectedComponent,
        TermsOfUseComponent,
        QuestionFiltersComponent,
        AssessmentDocumentsComponent,
        InlineParameterComponent,
        GlobalParametersComponent,
        ImportComponent,
        UploadExportComponent,
        KeyboardShortcutsComponent,
        LicenseComponent
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
        DemographicService,
        AssessmentService,
        EmailService,
        QuestionsService,
        SalService,
        StandardService,
        FrameworkService,
        FindingsService,
        NavigationService,
        FileUploadClientService,
        AnalysisService,
        EnableFeatureService
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
      LicenseComponent
    ]
})

export class AppModule { }
