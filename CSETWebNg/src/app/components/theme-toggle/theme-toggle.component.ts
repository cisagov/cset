import { Component, OnInit, OnDestroy, Input } from '@angular/core';
import { ThemeService, Theme } from '../../services/theme.service';
import { Subscription } from 'rxjs';
import { distinctUntilChanged } from 'rxjs/operators';

@Component({
  selector: 'app-theme-toggle',
  templateUrl: './theme-toggle.component.html',
  styleUrls: ['./theme-toggle.component.scss'],
  standalone: false
})
export class ThemeToggleComponent implements OnInit, OnDestroy {
  @Input() showText: boolean = true;
  @Input() forceWhiteFill: boolean = false;
  isDarkMode: boolean = false;
  private themeSubscription?: Subscription;

  constructor(private themeService: ThemeService) { }

  ngOnInit(): void {
    this.isDarkMode = this.themeService.getTheme() === 'dark';

    this.themeSubscription = this.themeService.theme$
      .pipe(distinctUntilChanged())
      .subscribe((theme: Theme) => {
        this.isDarkMode = theme === 'dark';
      });
  }

  ngOnDestroy(): void {
    if (this.themeSubscription) {
      this.themeSubscription.unsubscribe();
    }
  }

  toggleTheme(): void {
    this.themeService.toggleTheme();
  }
}