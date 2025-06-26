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
import { AfterViewInit, Component, OnInit, ViewEncapsulation } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { NewAssessmentDialogComponent } from '../../dialogs/new-assessment-dialog/new-assessment-dialog.component';
import { GalleryService } from '../../services/gallery.service';
import { trigger, style, animate, transition, state } from '@angular/animations';
import { NavigationService } from '../../services/navigation/navigation.service';
import { TranslocoService } from '@jsverse/transloco';
import { SwiperOptions } from 'swiper/types';



@Component({
  selector: 'app-new-assessment',
  standalone: false,
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
  ],
})
export class NewAssessmentComponent implements OnInit, AfterViewInit {
  hoverIndex = -1;

  constructor(
    public dialog: MatDialog,
    public gallerySvc: GalleryService,
    public navSvc: NavigationService,
    public tSvc: TranslocoService,
  ) {
  }

  ngOnInit(): void {
    this.gallerySvc.refreshCards();
  }

  ngAfterViewInit() {
    // Set a longer timeout to ensure DOM is fully rendered including dynamic content
    setTimeout(() => {
      this.initializeSwipers();
    }, 100);

    // Listen for changes to the DOM that might affect swiper containers
    const observer = new MutationObserver(() => {
      this.initializeSwipers();
    });

    // Start observing the document for added nodes
    observer.observe(document.body, { childList: true, subtree: true });
  }

  private initializeSwipers(): void {
    // Use querySelectorAll to get all swiper containers
    const swiperEls = document.querySelectorAll('swiper-container');
    const swiperConfig: SwiperOptions = {
      slidesPerView: "auto",
      spaceBetween: 7,
      navigation: {
        nextEl: '.swiper-button-next', // selector for external button
        prevEl: '.swiper-button-prev', // selector for external button
        disabledClass: 'swiper-button-hidden'
      },
      loop: false,
      breakpoints: {
        320: {
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
          slidesPerView: 5,
        }
      },
    }

    // Configure each swiper instance
    swiperEls.forEach(swiperEl => {
      // Skip already initialized swipers
      if (swiperEl.hasAttribute('data-initialized')) {
        return;
      }

      // Apply configuration to each swiper element
      Object.assign(swiperEl, swiperConfig);

      // Mark as initialized
      swiperEl.setAttribute('data-initialized', 'true');

      // Initialize this particular swiper instance
      // @ts-ignore - initialize method exists in Swiper web components but might not be in typings
      swiperEl.initialize();
    });
  }

  getImageSrc(src: string) {
    let path = "assets/images/cards/";
    if (src) {
      return path + src.toLowerCase();
    }
    return path + 'default.png';
  }

  onHover(i: number) {
    this.hoverIndex = i;
    if (i > 0) {
      var el = document.getElementById('c' + i.toString())?.parentElement;

      var bounding = el.getBoundingClientRect();

      let cardDimension = { x: bounding.x, y: bounding.y, w: bounding.width, h: bounding.height };
      let viewport = { x: 0, y: 0, w: window.innerWidth, h: window.innerHeight };
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

    var el = document.getElementById('c' + cardId.toString())?.parentElement;
    el.style.removeProperty('right');
  }

  openDialog(data: any) {
    data.path = this.getImageSrc(data.icon_File_Name_Small);
    this.dialog.open(NewAssessmentDialogComponent, {
      panelClass: 'new-assessment-dialog-responsive',
      data: data
    });
  }
  
}
