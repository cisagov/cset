////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
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
import { Component, OnInit } from '@angular/core';
import { SecurityQuestionAnswer } from '../../models/reset-pass.model';
import { AuthenticationService } from '../../services/authentication.service';
import { EmailService } from '../../services/email.service';
import { ConfigService } from '../../services/config.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
    selector: 'app-reset-pass',
    templateUrl: './reset-pass.component.html',
    // eslint-disable-next-line
    host: { class: 'd-flex flex-column flex-11a' },
    styleUrls: ['./reset-pass.component.scss']
})

export class ResetPassComponent implements OnInit {
    errorMsg = false;
    warning = '';
    model: any = {};

    showOrigin = true;

    questionsLoaded = false;

    securityQuestion: string;
    securityAnswer: string;
    loading = false;
    emailSent = false;
    enableNext = true;


    constructor(
        public tSvc: TranslocoService,
        private auth: AuthenticationService,
        public configSvc: ConfigService,
        private emailSvc: EmailService) { }


    /**
     *
     */
    ngOnInit() {
        switch (this.configSvc.installationMode) {
            case 'ACET':
            case 'RRA':
            case 'RENEW':
                this.showOrigin = false;
                break;
        }
    }

    showCsetLogo() {
        var i = this.configSvc.installationMode;
        if (i !== 'ACET' && i !== 'RRA') {
            return true;
        }
        return false;
    }

    showRraLogo() {
        var i = this.configSvc.installationMode;
        if (i === 'RRA') {
            return true;
        }
        return false;
    }

    loadQuestions() {
        this.loading = true;

        this.auth.getSecurityQuestionsList(this.model.email)
            .subscribe(
                (data: any[]) => {
                    this.warning = '';
                    this.loading = false;
                    this.errorMsg = false;

                    if (data.length === 0) {
                        this.enableNext = false;
                        this.emailSent = true;

                        this.warning = this.tSvc.translate('login.no questions defined');
                    } else {
                        this.questionsLoaded = true;
                        this.enableNext = false;

                        // dump any questions into an array and randomly pick one
                        const q: string[] = [];
                        if (data[0].securityQuestion1 !== null && data[0].securityQuestion1.length > 0) {
                            q.push(data[0].securityQuestion1);
                        }
                        if (data[0].securityQuestion2 !== null && data[0].securityQuestion2.length > 0) {
                            q.push(data[0].securityQuestion2);
                        }

                        this.securityQuestion = q[Math.floor(Math.random() * q.length)];
                    }
                },
                error => {
                    this.errorMsg = true;

                    if (error.error == 'user-inactive') {
                        this.warning = this.tSvc.translate('login.bad user');
                    } else {
                        this.warning = this.tSvc.translate('login.unknown email account');
                    }

                    this.handleError('Error retrieving security questions', error);
                });
    }

    /**
     * Send the question and answer along with the user's email for validation
     * and if valid, sending of an email.
     * Send the AppName also, because the user is not currently logged in, so there is no JWT.
     */
    resetPassword() {
        this.loading = true;
        const ans: SecurityQuestionAnswer = {
            primaryEmail: this.model.email,
            questionText: this.securityQuestion,
            answerText: this.securityAnswer,
            appName: this.configSvc.installationMode
        };

        this.emailSvc.sendPasswordResetEmail(ans)
            .subscribe(
                data => {
                    this.errorMsg = false;
                    this.warning = '';
                    this.emailSent = true;
                    this.loading = false;
                },
                error => {
                    this.errorMsg = true;
                    this.warning = error.status === 409 ? this.tSvc.translate('change password.answer incorrect') : error.statusText;
                    this.emailSent = false;
                    this.loading = false;
                    this.handleError('Error resetting password', error);
                });
    }

    private handleError(msg: string, error: Response | any) {
        this.loading = false;
        console.log(msg + (<Error>error).message);
        console.log(msg + (<Error>error).stack);
    }
}
