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
import { Component, Input, OnInit } from '@angular/core';
import { Subscription } from 'rxjs';
import { NavigationService } from '../../../services/navigation/navigation.service';

@Component({
  selector: 'app-nav-back-next',
  templateUrl: './nav-back-next.component.html'
})
export class NavBackNextComponent implements OnInit {

  @Input() page: string;

  @Input() hide: string;

  constructor(
    public navSvc: NavigationService
  ) {

  }

  nextMode = true;
  subscription: Subscription;
  ngOnInit(): void {
    this.subscription = this.navSvc.disableNext
      .asObservable()
      .subscribe(
        (tgt: boolean) => {
          this.nextMode = tgt;
        }
      );

    const isFirstVisible = this.navSvc.isFirstVisiblePage(this.page);
    if (isFirstVisible) {
      this.hide = 'back';
    }
    this.nextMode = this.navSvc.isNextEnabled(this.page);

  }
  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }
}
