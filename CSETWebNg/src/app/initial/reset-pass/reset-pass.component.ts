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
import { Component } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { SecurityQuestionAnswer } from '../../models/reset-pass.model';
import { AuthenticationService } from '../../services/authentication.service';
import { EmailService } from '../../services/email.service';
import { environment } from '../../../environments/environment.prod';
import { ConfigService } from '../../services/config.service';

@Component({
    selector: 'app-reset-pass',
    templateUrl: './reset-pass.component.html',
    // tslint:disable-next-line:use-host-property-decorator
    host: {class: 'd-flex flex-column flex-11a'}, 
    styleUrls: ['./reset-pass.component.scss'] 
})

export class ResetPassComponent {
    errorMsg = false;
    warning = '';
    model: any = {};

    questionsLoaded = false;

    securityQuestion: string;
    securityAnswer: string;
    loading = false;
    emailSent = false;
    enableNext = true;


    constructor(
        private route: ActivatedRoute,
        private router: Router,
        private auth: AuthenticationService,
        public configSvc: ConfigService,
        private emailSvc: EmailService) { }


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

                        this.warning = 'You have no security questions defined for your account. '
                            + 'Please consider adding security questions the next time you are logged in.';
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
                    this.warning = 'Unknown email account';
                    this.errorMsg = true;
                    this.handleError('Error retrieving security questions', error);
                });
    }

    /**
     * Send the question and answer along with the user's email for validation
     * and if valid, sending of an email.
     * Send the AppCode also, because the user is not currently logged in, so there is no JWT.
     */
    resetPassword() {
        this.loading = true;
        const ans: SecurityQuestionAnswer = {
            PrimaryEmail: this.model.email,
            QuestionText: this.securityQuestion,
            AnswerText: this.securityAnswer,
            AppCode: environment.appCode
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
                    this.warning = error.status === 409 ? 'The answer is incorrect' : error.statusText;
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
