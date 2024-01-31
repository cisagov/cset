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
import { AfterViewInit, Component, OnInit, ViewChild, ViewEncapsulation } from '@angular/core';
import SwiperCore, { SwiperOptions, Navigation, Pagination, Virtual } from 'swiper';
import { MatDialog } from '@angular/material/dialog';
import { NewAssessmentDialogComponent } from '../../dialogs/new-assessment-dialog/new-assessment-dialog.component';
import { AssessmentService } from '../../services/assessment.service';
import { BreakpointObserver } from '@angular/cdk/layout';
import { SwiperComponent } from 'swiper/angular';
import { GalleryService } from '../../services/gallery.service';
import { trigger, style, animate, transition, state } from '@angular/animations';
import { ConfigService } from '../../services/config.service';
import { NavigationService } from '../../services/navigation/navigation.service';
import { TranslocoService } from '@ngneat/transloco';

SwiperCore.use([Navigation, Pagination, Virtual]);
@Component({
  selector: 'app-new-assessment',
  templateUrl: './new-assessment.component.html',
  styleUrls: ['./new-assessment.component.scss'],
  encapsulation: ViewEncapsulation.None,
  animations: [
    trigger('enterAnimation', [
      state('false', style({ overflow: 'hidden', height: '0px', padding: '0 10px 0 0' })),
      state('true', style({ overflow: 'hidden', height: '*', padding: '0 10px 10px 0' })),
      transition('false => true', animate('200ms ease-in')),
      transition('true => false', animate('200ms ease-out'))
    ]),
  ]
})
export class NewAssessmentComponent implements OnInit, AfterViewInit {

  @ViewChild('swiper', { static: false }) swiper?: SwiperComponent;

  hoverIndex = -1;
  config: SwiperOptions = {
    slidesPerView: 1,
    spaceBetween: 7,
    slidesPerGroup: 1,
    //loop:true,
    navigation: true,
    breakpoints: {
      200: {
        slidesPerView: 1,
      },
      620: {
        slidesPerView: 2,
      },
      800: {
        slidesPerView: 3,
      },
      1220: {
        slidesPerView: 4,
      },
      1460: {
        slidesPerView: 5
      }
    },
    on: {
      resize: () => {
        this.checkNavigation();
      }
    }
  };

  pageTitle: string;
  show: boolean = false;

  constructor(public dialog: MatDialog,
    public breakpointObserver: BreakpointObserver,
    public gallerySvc: GalleryService,
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public tSvc: TranslocoService,
    ) {
  }

  ngOnInit(): void {
    this.pageTitle = this.tSvc.translate('to start an assessment').replace('{icon}', '<i class="fa-solid fa-circle-info" style="font-size: 1.3rem;"></i>');
    this.gallerySvc.refreshCards();
    this.checkNavigation();
  }

  ngAfterViewInit(): void {
    this.checkNavigation();
  }

  checkNavigation() {
    let swiperPrev = document.getElementsByClassName('swiper-button-prev');
    let swiperNext = document.getElementsByClassName('swiper-button-next');
    if (window.innerWidth < 620) {
      if (swiperPrev != null && swiperNext != null) {
        for (var i = 0; i < swiperPrev.length; i++) {
          swiperPrev[i].setAttribute('style', 'display:none');
          swiperNext[i].setAttribute('style', 'display:none');
        }
      }
    } else {
      if (swiperPrev != null && swiperNext != null) {
        for (var i = 0; i < swiperPrev.length; i++) {
          swiperPrev[i].removeAttribute('style');
          swiperNext[i].removeAttribute('style');
        }
      }
    }
  }

  onHover(i: number) {
    this.hoverIndex = i;
    if (i > 0) {
      var el = document.getElementById('c' + i.toString()).parentElement;

      var bounding = el.getBoundingClientRect();

      let cardDimension = { x: bounding.x, y: bounding.y, w: bounding.width, h: bounding.height };
      let viewport = { x: 0, y: 0, w: window.innerWidth, h: window.innerHeight };
      let cardSize = cardDimension.w * cardDimension.h;
      let xOverlap = Math.max(0, Math.min(cardDimension.x + cardDimension.w, viewport.x + viewport.w) - Math.max(cardDimension.x, viewport.x))
      //let yOverlap = Math.max(0, Math.min(cardDimension.y + cardDimension.y, viewport.y + viewport.h) - Math.max(cardDimension.y, viewport.y))
      let offScreen = cardDimension.w - xOverlap;
      if (offScreen > 5) {
        el.style.right = (cardDimension.w).toString() + 'px';
      }
    }
  }

  onHoverOut(i: number, cardId: number) {
    this.hoverIndex = i;

    var el = document.getElementById('c' + cardId.toString()).parentElement;
    el.style.removeProperty('right');
  }

  showButtons(show: boolean) {
    this.show = show;
  }

  onSlideChange() { }

  getImageSrc(src: string) {
    let path = "assets/images/cards/";
    if (src) {
      return path + src;
    }
    return path + 'default.png';
  }

  openDialog(data: any) {
    data.path = this.getImageSrc(data.icon_File_Name_Small);
    this.dialog.open(NewAssessmentDialogComponent, {
      panelClass: 'new-assessment-dialog-responsive',
      data: data
    });
  }

}
