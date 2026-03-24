////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { Router } from '@angular/router';
import { OAuthService } from 'angular-oauth2-oidc';

@Component({
  selector: 'app-logout',
  templateUrl: './logout.component.html',
  standalone: false
})
export class LogoutComponent implements OnInit {

  constructor(
    private router: Router
  ) { }

  /**
   *
   */
  async ngOnInit(): Promise<void> {
    // Grab a couple of items that should be persisted across sessions
    const savedLang = localStorage.getItem('cset-language');
    const savedTheme = localStorage.getItem('cset-theme');
    
    localStorage.clear();

    // Restore those items
    if (savedTheme) {
      localStorage.setItem('cset-theme', savedTheme);
    }
    if (savedLang) {
      localStorage.setItem('cset-language', savedLang);
    }


    sessionStorage.removeItem('cset-assessments-page');

    this.router.navigate(['/home/login'], { queryParamsHandling: "preserve" });
  }
}
