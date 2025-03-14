import { AfterViewInit, Component, CUSTOM_ELEMENTS_SCHEMA, OnInit } from '@angular/core';
import { SwiperOptions } from 'swiper/types';
import { CommonModule } from '@angular/common';
import { GalleryService } from '../services/gallery.service';
import { animate, state, style, transition, trigger } from '@angular/animations';
import { NewAssessmentDialogComponent } from '../dialogs/new-assessment-dialog/new-assessment-dialog.component';
import { MatDialog } from '@angular/material/dialog';
import { TranslocoService } from '@jsverse/transloco';
import { register as registerSwiper } from 'swiper/element/bundle';
import { NavigationService } from '../services/navigation/navigation.service';
import { TranslocoRootModule } from '../transloco-root.module';
import { EllipsisModule } from '../modules/ngx-ellipsis/ellipsis.module';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatToolbarModule } from '@angular/material/toolbar';

registerSwiper()

@Component({
  selector: 'app-test-swiper',
  standalone: true,
  imports: [CommonModule, TranslocoRootModule, EllipsisModule, MatTooltipModule, MatToolbarModule],
  templateUrl: './test-swiper.component.html',
  styleUrl: './test-swiper.component.scss',
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  animations: [
    trigger('enterAnimation', [
      state('false', style({ overflow: 'hidden', height: '0px', padding: '0 10px 0 0' })),
      state('true', style({ overflow: 'hidden', height: '*', padding: '0 10px 10px 0' })),
      transition('false => true', animate('200ms ease-in')),
      transition('true => false', animate('200ms ease-out'))
    ]),
  ],
})
export class TestSwiperComponent implements OnInit, AfterViewInit {
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
      navigation: true,
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

  openDialog(data: any) {
    data.path = this.getImageSrc(data.icon_File_Name_Small);
    this.dialog.open(NewAssessmentDialogComponent, {
      panelClass: 'new-assessment-dialog-responsive',
      data: data
    });
  }
}
