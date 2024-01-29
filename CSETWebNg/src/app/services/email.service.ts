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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { SecurityQuestionAnswer } from '../models/reset-pass.model';
import { CreateUser } from '../models/user.model';
import { ConfigService } from './config.service';

const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable()
export class EmailService {
  // eslint-disable-next-line max-len
  // regex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

  // eslint-disable-next-line max-len
  regex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9])+([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

  private apiUrl: string;
  private initialized = false;

  constructor(private http: HttpClient, private configSvc: ConfigService) {
    if (!this.initialized) {
      this.apiUrl = configSvc.apiUrl;
      this.initialized = true;
    }
  }

  validAddress(address: string) {
    return this.regex.test(address);
  }

  sendInvites(subject: string, body: string, addresses: string[]) {
    return this.http.post(this.apiUrl + 'contacts/invite', {
      Subject: subject,
      Body: body,
      InviteeList: addresses
    }, headers);
  }

  sendPasswordResetEmail(data: SecurityQuestionAnswer) {
    return this.http.post(this.apiUrl + 'ResetPassword', JSON.stringify(data), headers);
  }

  sendCreateUserEmail(data: CreateUser) {
    return this.http.post(this.apiUrl + 'ResetPassword/RegisterUser', data, { 'headers': headers.headers, params: headers.params, responseType: 'text' });
  }

  makeEmailList(text) {
    // Join the emails into a formatted list.
    return this.getCleanEmailList(text).join("; ");
  }

  getCleanEmailList(text) {
    /* Get each word from the text, split by spaces, end line, semicolon, quotes, commas, colons, parens,
       and brackets.
    */
    if (text == null) { return; }
    const words = text.split(/[\s\n;"',;:()<>[\]\\]+/);
    const emails = [];
    let distinct_emails;

    // Regex for identifying an email address.


    // For each of the words, add to the array of emails if the word matches the email regex.
    for (const key in words) {
      if (words[key].match(this.regex)) { emails.push(words[key].toLowerCase()); }
    }

    // Remove duplicate entries from the emails array.
    distinct_emails = this.removeDuplicateElement(emails);
    return distinct_emails;

  }

  removeDuplicateElement(arrayName) {
    const newArray = [], len = arrayName.length;
    let newLen, found_duplicate = false;
    /* Compare each email to every other email and push an email onto the new array if
       a duplicate wasn't found.
    */
    for (let i = 0; i < len; i += 1) {
      newLen = newArray.length;
      for (let j = 0; j < newLen; j += 1) {
        if (newArray[j] === arrayName[i]) {
          found_duplicate = true;
          break;
        }
      }
      found_duplicate ? found_duplicate = false : newArray.push(arrayName[i]);
    }
    return newArray;
  }
}
