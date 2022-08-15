import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrCoverSheet2Component } from './crr-cover-sheet2.component';

describe('CrrCoverSheet2Component', () => {
  let component: CrrCoverSheet2Component;
  let fixture: ComponentFixture<CrrCoverSheet2Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrCoverSheet2Component ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrCoverSheet2Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
