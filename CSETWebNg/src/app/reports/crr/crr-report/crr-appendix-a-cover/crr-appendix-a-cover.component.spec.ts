import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrAppendixACoverComponent } from './crr-appendix-a-cover.component';

describe('CrrAppendixACoverComponent', () => {
  let component: CrrAppendixACoverComponent;
  let fixture: ComponentFixture<CrrAppendixACoverComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrAppendixACoverComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrAppendixACoverComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
