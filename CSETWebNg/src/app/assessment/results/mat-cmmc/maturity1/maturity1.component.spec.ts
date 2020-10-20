import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Maturity1Component } from './maturity1.component';

describe('Maturity1Component', () => {
  let component: Maturity1Component;
  let fixture: ComponentFixture<Maturity1Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Maturity1Component ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Maturity1Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
