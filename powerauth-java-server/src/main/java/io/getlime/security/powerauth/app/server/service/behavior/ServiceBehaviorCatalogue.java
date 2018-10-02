/*
 * PowerAuth Server and related software components
 * Copyright (C) 2018 Wultra s.r.o.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package io.getlime.security.powerauth.app.server.service.behavior;

import io.getlime.security.powerauth.app.server.service.behavior.tasks.v2.EncryptionServiceBehavior;
import io.getlime.security.powerauth.app.server.service.behavior.tasks.v3.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Collection of all behaviors used by the PowerAuth 2.0 Server service.
 *
 * @author Petr Dvorak, petr@wultra.com
 */
@Component
public class ServiceBehaviorCatalogue {

    private ActivationServiceBehavior activationServiceBehavior;

    private ActivationHistoryServiceBehavior activationHistoryServiceBehavior;

    private ApplicationServiceBehavior applicationServiceBehavior;

    private AuditingServiceBehavior auditingServiceBehavior;

    private SignatureServiceBehavior signatureServiceBehavior;

    private VaultUnlockServiceBehavior vaultUnlockServiceBehavior;

    private IntegrationBehavior integrationBehavior;

    private CallbackUrlBehavior callbackUrlBehavior;

    private AsymmetricSignatureServiceBehavior asymmetricSignatureServiceBehavior;

    private TokenBehavior tokenBehavior;

    private EciesEncryptionBehavior eciesEncryptionBehavior;

    private ServiceBehaviorCatalogueV2 serviceBehaviorCatalogueV2;

    public ActivationServiceBehavior getActivationServiceBehavior() {
        return activationServiceBehavior;
    }

    @Autowired
    public void setActivationServiceBehavior(ActivationServiceBehavior activationServiceBehavior) {
        this.activationServiceBehavior = activationServiceBehavior;
    }

    @Autowired
    public void setActivationHistoryServiceBehavior(ActivationHistoryServiceBehavior activationHistoryServiceBehavior) {
        this.activationHistoryServiceBehavior = activationHistoryServiceBehavior;
    }

    @Autowired
    public void setApplicationServiceBehavior(ApplicationServiceBehavior applicationServiceBehavior) {
        this.applicationServiceBehavior = applicationServiceBehavior;
    }

    @Autowired
    public void setAuditingServiceBehavior(AuditingServiceBehavior auditingServiceBehavior) {
        this.auditingServiceBehavior = auditingServiceBehavior;
    }

    @Autowired
    public void setSignatureServiceBehavior(SignatureServiceBehavior signatureServiceBehavior) {
        this.signatureServiceBehavior = signatureServiceBehavior;
    }

    @Autowired
    public void setVaultUnlockServiceBehavior(VaultUnlockServiceBehavior vaultUnlockServiceBehavior) {
        this.vaultUnlockServiceBehavior = vaultUnlockServiceBehavior;
    }

    @Autowired
    public void setIntegrationBehavior(IntegrationBehavior integrationBehavior) {
        this.integrationBehavior = integrationBehavior;
    }

    @Autowired
    public void setCallbackUrlBehavior(CallbackUrlBehavior callbackUrlBehavior) {
        this.callbackUrlBehavior = callbackUrlBehavior;
    }

    @Autowired
    public void setAsymmetricSignatureServiceBehavior(AsymmetricSignatureServiceBehavior asymmetricSignatureServiceBehavior) {
        this.asymmetricSignatureServiceBehavior = asymmetricSignatureServiceBehavior;
    }

    @Autowired
    public void setTokenBehavior(TokenBehavior tokenBehavior) {
        this.tokenBehavior = tokenBehavior;
    }

    @Autowired
    public void setEciesEncryptionBehavior(EciesEncryptionBehavior eciesEncryptionBehavior) {
        this.eciesEncryptionBehavior = eciesEncryptionBehavior;
    }

    @Autowired
    public void setServiceBehaviorCatalogueV2(ServiceBehaviorCatalogueV2 serviceBehaviorCatalogueV2) {
        this.serviceBehaviorCatalogueV2 = serviceBehaviorCatalogueV2;
    }

    public ApplicationServiceBehavior getApplicationServiceBehavior() {
        return applicationServiceBehavior;
    }

    public ActivationHistoryServiceBehavior getActivationHistoryServiceBehavior() {
        return activationHistoryServiceBehavior;
    }

    public AuditingServiceBehavior getAuditingServiceBehavior() {
        return auditingServiceBehavior;
    }

    public SignatureServiceBehavior getSignatureServiceBehavior() {
        return signatureServiceBehavior;
    }

    public VaultUnlockServiceBehavior getVaultUnlockServiceBehavior() {
        return vaultUnlockServiceBehavior;
    }

    public IntegrationBehavior getIntegrationBehavior() {
        return integrationBehavior;
    }

    public CallbackUrlBehavior getCallbackUrlBehavior() {
        return callbackUrlBehavior;
    }

    public AsymmetricSignatureServiceBehavior getAsymmetricSignatureServiceBehavior() {
        return asymmetricSignatureServiceBehavior;
    }

    public TokenBehavior getTokenBehavior() {
        return tokenBehavior;
    }

    public EciesEncryptionBehavior getEciesEncryptionBehavior() {
        return eciesEncryptionBehavior;
    }

    public ServiceBehaviorCatalogueV2 v2() {
        return serviceBehaviorCatalogueV2;
    }

    @Component
    public class ServiceBehaviorCatalogueV2 {

        private io.getlime.security.powerauth.app.server.service.behavior.tasks.v2.ActivationServiceBehavior activationServiceBehavior;

        private io.getlime.security.powerauth.app.server.service.behavior.tasks.v2.EncryptionServiceBehavior encryptionServiceBehavior;

        private io.getlime.security.powerauth.app.server.service.behavior.tasks.v2.VaultUnlockServiceBehavior vaultUnlockServiceBehavior;

        private io.getlime.security.powerauth.app.server.service.behavior.tasks.v2.TokenBehavior tokenBehavior;

        @Autowired
        public void setActivationServiceBehavior(io.getlime.security.powerauth.app.server.service.behavior.tasks.v2.ActivationServiceBehavior activationServiceBehavior) {
            this.activationServiceBehavior = activationServiceBehavior;
        }

        @Autowired
        public void setEncryptionServiceBehavior(EncryptionServiceBehavior encryptionServiceBehavior) {
            this.encryptionServiceBehavior = encryptionServiceBehavior;
        }

        @Autowired
        public void setVaultUnlockServiceBehavior(io.getlime.security.powerauth.app.server.service.behavior.tasks.v2.VaultUnlockServiceBehavior vaultUnlockServiceBehavior) {
            this.vaultUnlockServiceBehavior = vaultUnlockServiceBehavior;
        }

        @Autowired
        public void setTokenBehavior(io.getlime.security.powerauth.app.server.service.behavior.tasks.v2.TokenBehavior tokenBehavior) {
            this.tokenBehavior = tokenBehavior;
        }

        public io.getlime.security.powerauth.app.server.service.behavior.tasks.v2.ActivationServiceBehavior getActivationServiceBehavior() {
            return activationServiceBehavior;
        }

        public io.getlime.security.powerauth.app.server.service.behavior.tasks.v2.EncryptionServiceBehavior getEncryptionServiceBehavior() {
            return encryptionServiceBehavior;
        }

        public io.getlime.security.powerauth.app.server.service.behavior.tasks.v2.TokenBehavior getTokenBehavior() {
            return tokenBehavior;
        }

        public io.getlime.security.powerauth.app.server.service.behavior.tasks.v2.VaultUnlockServiceBehavior getVaultUnlockServiceBehavior() {
            return vaultUnlockServiceBehavior;
        }
    }
}
