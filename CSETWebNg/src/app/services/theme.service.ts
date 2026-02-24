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

import { Injectable, Renderer2, RendererFactory2, Inject } from '@angular/core';
import { DOCUMENT } from '@angular/common';
import { BehaviorSubject, Observable } from 'rxjs';

export type Theme = 'light' | 'dark';

@Injectable({
  providedIn: 'root'
})
export class ThemeService {
  private renderer: Renderer2;
  private currentTheme: BehaviorSubject<Theme>;
  private readonly THEME_KEY = 'cset-theme';

  public theme$: Observable<Theme>;

  constructor(
    rendererFactory: RendererFactory2,
    @Inject(DOCUMENT) private document: Document
  ) {
    this.renderer = rendererFactory.createRenderer(null, null);

    // Initialize theme from localStorage or system preference
    const savedTheme = this.getSavedTheme();
    this.currentTheme = new BehaviorSubject<Theme>(savedTheme);
    this.theme$ = this.currentTheme.asObservable();

    // Apply initial theme
    this.applyTheme(savedTheme, false);
  }

  /**
   * Get the current theme
   */
  getTheme(): Theme {
    return this.currentTheme.value;
  }

  /**
   * Check if dark mode is active
   */
  isDarkMode(): boolean {
    return this.currentTheme.value === 'dark';
  }

  /**
   * Toggle between light and dark themes
   */
  toggleTheme(): void {
    const newTheme: Theme = this.currentTheme.value === 'light' ? 'dark' : 'light';
    this.setTheme(newTheme);
  }

  /**
   * Set a specific theme
   */
  setTheme(theme: Theme): void {
    if (this.currentTheme.value !== theme) {
      this.applyTheme(theme);
      this.currentTheme.next(theme);
      localStorage.setItem(this.THEME_KEY, theme);
    }
  }

  /**
   * Get saved theme from localStorage or detect system preference
   */
  private getSavedTheme(): Theme {
    const savedTheme = localStorage.getItem(this.THEME_KEY) as Theme;

    if (savedTheme && (savedTheme === 'light' || savedTheme === 'dark')) {
      return savedTheme;
    }

    // Check system preference
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      return 'dark';
    }

    return 'light';
  }

  /**
   * Apply theme to the DOM
   */
  private applyTheme(theme: Theme, animate: boolean = true): void {
    const htmlElement = this.document.documentElement;
    const bodyElement = this.document.body;

    // Remove old theme classes
    this.renderer.removeClass(htmlElement, 'light-theme');
    this.renderer.removeClass(htmlElement, 'dark-theme');
    this.renderer.removeClass(bodyElement, 'light-theme');
    this.renderer.removeClass(bodyElement, 'dark-theme');

    // Add transition class for smooth theme switching
    if (animate) {
      this.renderer.addClass(bodyElement, 'theme-transition');
    }

    // Apply new theme class to html and body
    this.renderer.addClass(htmlElement, `${theme}-theme`);
    this.renderer.addClass(bodyElement, `${theme}-theme`);

    // Set data-theme attribute for DaisyUI
    this.renderer.setAttribute(htmlElement, 'data-theme', theme);

    // Set Bootstrap color-mode attribute
    this.renderer.setAttribute(htmlElement, 'data-bs-theme', theme);

    // Apply Material theme class
    if (theme === 'dark') {
      this.renderer.addClass(bodyElement, 'mat-app-background');
      this.renderer.addClass(bodyElement, 'dark-mode');
    } else {
      this.renderer.removeClass(bodyElement, 'dark-mode');
    }

    // Remove transition class after animation completes
    if (animate) {
      setTimeout(() => {
        this.renderer.removeClass(bodyElement, 'theme-transition');
      }, 300);
    }
  }

  /**
   * Listen to system theme changes
   */
  watchSystemTheme(): void {
    if (window.matchMedia) {
      const darkModeQuery = window.matchMedia('(prefers-color-scheme: dark)');

      darkModeQuery.addEventListener('change', (e) => {
        // Only auto-switch if user hasn't manually set a preference
        if (!localStorage.getItem(this.THEME_KEY)) {
          const newTheme: Theme = e.matches ? 'dark' : 'light';
          this.setTheme(newTheme);
        }
      });
    }
  }

  /**
   * Returns a hex HTML color code with a new alpha (opacity) value applied.
   * The input color code can be hex or rgba.
   * @param color 
   * @param newAlpha 
   * @returns 
   */
  updateAlpha(color: string, newAlpha: number): string {
    // Ensure the alpha value is between 0 and 1
    newAlpha = Math.max(0, Math.min(1, newAlpha));

    // Check if the color is in rgba format
    const rgbaMatch = color.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+),?\s*([\d\.]*)\)$/);

    if (rgbaMatch) {
      const [, r, g, b] = rgbaMatch;
      return `rgba(${r}, ${g}, ${b}, ${newAlpha})`;
    }

    // Check if the color is in hex format
    const hexMatch = color.match(/^#([0-9a-f]{8}|[0-9a-f]{6}|[0-9a-f]{3})$/i);

    if (hexMatch) {
      let hexValue = hexMatch[1];

      if (hexValue.length === 3) {
        hexValue = hexValue.split('').map(char => char + char).join('');
      }

      if (hexValue.length === 6) {
        hexValue += Math.round(newAlpha * 255).toString(16).padStart(2, '0');
      } else if (hexValue.length === 8) {
        hexValue = hexValue.slice(0, 6) + Math.round(newAlpha * 255).toString(16).padStart(2, '0');
      }

      return `#${hexValue}`;
    }

    throw new Error('Invalid color format');
  }
}
