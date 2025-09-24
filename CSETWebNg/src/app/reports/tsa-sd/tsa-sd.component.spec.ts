import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TsaSdComponent } from './tsa-sd.component';

describe('TsaSdComponent', () => {
  let component: TsaSdComponent;
  let fixture: ComponentFixture<TsaSdComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [TsaSdComponent]
    });
    fixture = TestBed.createComponent(TsaSdComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
