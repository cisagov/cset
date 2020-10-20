import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Maturity2Component } from './maturity2.component';

describe('Maturity2Component', () => {
  let component: Maturity2Component;
  let fixture: ComponentFixture<Maturity2Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Maturity2Component ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Maturity2Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
