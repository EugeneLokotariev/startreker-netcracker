import {Component, Input, OnInit} from '@angular/core';
import {FormControl, FormGroup, Validators} from '@angular/forms';

import {Service} from '../shared/model/service';
import {ServiceService} from '../shared/service/service.service';

@Component({
  selector: 'app-assigned',
  templateUrl: './assigned.component.html',
  styleUrls: ['./assigned.component.scss']
})
export class AssignedComponent implements OnInit {

  @Input() services: Service[];

  form: FormGroup;

  currentServiceForReply: Service;

  loadingService: Service;

  setFormInDefault() {
    this.form = new FormGroup(
      {
        reply_text: new FormControl('', [Validators.required]),
      }
    );
  }

  onWriteReply(serviceForReply) {
    this.currentServiceForReply = serviceForReply;
  }

  resetReply() {
    this.currentServiceForReply = null;
  }

  resetLoading() {
    this.loadingService = null;
  }

  onPublish(service) {
    service.service_status = 4;

    this.loadingService = service;

    this.serviceService.updateServiceReview(service)
    .subscribe(() => {
      this.getServices();
      alert(service.service_name + ' is now published');
    }, () => {
      this.resetLoading();
      alert('Something went wrong');
    });
  }

  onReview(service) {
    service.service_status = 5;
    service.reply_text = this.form.value.reply_text;

    this.loadingService = service;

    this.serviceService.updateServiceReview(service)
    .subscribe(() => {
      this.getServices();
      alert(service.service_name + ' is now under clarification');
    }, () => {
      this.resetLoading();
      alert('Something went wrong');
    });
  }

  getServices() {
    this.serviceService.getServicesForApprover(0, 10, 3)
    .subscribe(data => {
      this.resetLoading();
      this.services = data;
    });
  }

  constructor(private serviceService: ServiceService) { }

  ngOnInit() {
    this.setFormInDefault();
    this.getServices();
  }

}
