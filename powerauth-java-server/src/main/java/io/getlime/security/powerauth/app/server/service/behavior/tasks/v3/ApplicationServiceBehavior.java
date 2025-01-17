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
package io.getlime.security.powerauth.app.server.service.behavior.tasks.v3;

import com.google.common.io.BaseEncoding;
import io.getlime.security.powerauth.app.server.database.RepositoryCatalogue;
import io.getlime.security.powerauth.app.server.database.model.entity.ApplicationEntity;
import io.getlime.security.powerauth.app.server.database.model.entity.ApplicationVersionEntity;
import io.getlime.security.powerauth.app.server.database.model.entity.MasterKeyPairEntity;
import io.getlime.security.powerauth.app.server.service.exceptions.GenericServiceException;
import io.getlime.security.powerauth.app.server.service.i18n.LocalizationProvider;
import io.getlime.security.powerauth.app.server.service.model.ServiceError;
import io.getlime.security.powerauth.crypto.lib.generator.KeyGenerator;
import io.getlime.security.powerauth.provider.CryptoProviderUtil;
import io.getlime.security.powerauth.provider.exception.CryptoProviderException;
import io.getlime.security.powerauth.v3.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.security.KeyPair;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * Behavior class implementing the application management related processes. The class separates the
 * logic from the main service class.
 *
 * @author Petr Dvorak, petr@wultra.com
 */
@Component
public class ApplicationServiceBehavior {

    private final RepositoryCatalogue repositoryCatalogue;
    private final LocalizationProvider localizationProvider;

    // Prepare logger
    private static final Logger logger = LoggerFactory.getLogger(ApplicationServiceBehavior.class);

    @Autowired
    public ApplicationServiceBehavior(RepositoryCatalogue repositoryCatalogue, LocalizationProvider localizationProvider) {
        this.repositoryCatalogue = repositoryCatalogue;
        this.localizationProvider = localizationProvider;
    }

    /**
     * Get application details by ID.
     *
     * @param applicationId Application ID
     * @return Response with application details
     * @throws GenericServiceException Thrown when application does not exist.
     */
    public GetApplicationDetailResponse getApplicationDetail(Long applicationId) throws GenericServiceException {
        ApplicationEntity application = findApplicationById(applicationId);
        return createApplicationDetailResponse(application);
    }

    /**
     * Get application details by name.
     *
     * @param applicationName Application name
     * @return Response with application details
     * @throws GenericServiceException Thrown when application does not exist.
     */
    public GetApplicationDetailResponse getApplicationDetailByName(String applicationName) throws GenericServiceException {
        ApplicationEntity application = findApplicationByName(applicationName);
        return createApplicationDetailResponse(application);
    }

    private GetApplicationDetailResponse createApplicationDetailResponse(ApplicationEntity application) throws GenericServiceException {
        GetApplicationDetailResponse response = new GetApplicationDetailResponse();
        response.setApplicationId(application.getId());
        response.setApplicationName(application.getName());
        MasterKeyPairEntity masterKeyPairEntity = repositoryCatalogue.getMasterKeyPairRepository().findFirstByApplicationIdOrderByTimestampCreatedDesc(application.getId());
        if (masterKeyPairEntity == null) {
            // This can happen only when an application was not created properly using PA Server service
            logger.error("Missing key pair for application ID: {}", application.getId());
            throw localizationProvider.buildExceptionForCode(ServiceError.NO_MASTER_SERVER_KEYPAIR);
        }
        response.setMasterPublicKey(masterKeyPairEntity.getMasterKeyPublicBase64());

        List<ApplicationVersionEntity> versions = repositoryCatalogue.getApplicationVersionRepository().findByApplicationId(application.getId());
        for (ApplicationVersionEntity version : versions) {

            GetApplicationDetailResponse.Versions ver = new GetApplicationDetailResponse.Versions();
            ver.setApplicationVersionId(version.getId());
            ver.setApplicationKey(version.getApplicationKey());
            ver.setApplicationSecret(version.getApplicationSecret());
            ver.setApplicationVersionName(version.getName());
            ver.setSupported(version.getSupported());

            response.getVersions().add(ver);
        }

        return response;
    }

    /**
     * Lookup application based on version app key.
     *
     * @param appKey Application version key (APP_KEY).
     * @return Response with application details
     * @throws GenericServiceException Thrown when application does not exist.
     */
    public LookupApplicationByAppKeyResponse lookupApplicationByAppKey(String appKey) throws GenericServiceException {
        ApplicationVersionEntity applicationVersion = repositoryCatalogue.getApplicationVersionRepository().findByApplicationKey(appKey);
        if (applicationVersion == null) {
            logger.warn("Application version is incorrect, application key: {}", appKey);
            throw localizationProvider.buildExceptionForCode(ServiceError.INVALID_APPLICATION);
        }
        ApplicationEntity application = findApplicationById(applicationVersion.getApplication().getId());
        LookupApplicationByAppKeyResponse response = new LookupApplicationByAppKeyResponse();
        response.setApplicationId(application.getId());
        return response;
    }

    /**
     * Get application list in the PowerAuth Server instance.
     *
     * @return List of applications.
     */
    public GetApplicationListResponse getApplicationList() {

        Iterable<ApplicationEntity> result = repositoryCatalogue.getApplicationRepository().findAll();

        GetApplicationListResponse response = new GetApplicationListResponse();

        for (ApplicationEntity application : result) {
            GetApplicationListResponse.Applications app = new GetApplicationListResponse.Applications();
            app.setId(application.getId());
            app.setApplicationName(application.getName());
            response.getApplications().add(app);
        }

        return response;
    }

    /**
     * Create a new application with given name.
     *
     * @param name                   Application name
     * @param keyConversionUtilities Utility class for the key conversion
     * @return Response with new application information
     * @throws GenericServiceException In case cryptography provider is initialized incorrectly.
     */
    public CreateApplicationResponse createApplication(String name, CryptoProviderUtil keyConversionUtilities) throws GenericServiceException {
        try {
            ApplicationEntity application = new ApplicationEntity();
            application.setName(name);
            application = repositoryCatalogue.getApplicationRepository().save(application);

            KeyGenerator keyGen = new KeyGenerator();
            KeyPair kp = keyGen.generateKeyPair();
            PrivateKey privateKey = kp.getPrivate();
            PublicKey publicKey = kp.getPublic();

            // Generate the default master key pair
            MasterKeyPairEntity keyPair = new MasterKeyPairEntity();
            keyPair.setApplication(application);
            keyPair.setMasterKeyPrivateBase64(BaseEncoding.base64().encode(keyConversionUtilities.convertPrivateKeyToBytes(privateKey)));
            keyPair.setMasterKeyPublicBase64(BaseEncoding.base64().encode(keyConversionUtilities.convertPublicKeyToBytes(publicKey)));
            keyPair.setTimestampCreated(new Date());
            keyPair.setName(name + " Default Keypair");
            repositoryCatalogue.getMasterKeyPairRepository().save(keyPair);

            // Create the default application version
            byte[] applicationKeyBytes = keyGen.generateRandomBytes(16);
            byte[] applicationSecretBytes = keyGen.generateRandomBytes(16);
            ApplicationVersionEntity version = new ApplicationVersionEntity();
            version.setApplication(application);
            version.setName("default");
            version.setSupported(true);
            version.setApplicationKey(BaseEncoding.base64().encode(applicationKeyBytes));
            version.setApplicationSecret(BaseEncoding.base64().encode(applicationSecretBytes));
            repositoryCatalogue.getApplicationVersionRepository().save(version);

            CreateApplicationResponse response = new CreateApplicationResponse();
            response.setApplicationId(application.getId());
            response.setApplicationName(application.getName());

            return response;
        } catch (CryptoProviderException ex) {
            logger.error(ex.getMessage(), ex);
            throw localizationProvider.buildExceptionForCode(ServiceError.INVALID_CRYPTO_PROVIDER);
        }
    }

    /**
     * Create a new application version
     *
     * @param applicationId Application ID
     * @param versionName   Application version name
     * @return Response with new version information
     * @throws GenericServiceException Thrown when application does not exist.
     */
    public CreateApplicationVersionResponse createApplicationVersion(Long applicationId, String versionName) throws GenericServiceException {

        ApplicationEntity application = findApplicationById(applicationId);

        KeyGenerator keyGen = new KeyGenerator();
        byte[] applicationKeyBytes = keyGen.generateRandomBytes(16);
        byte[] applicationSecretBytes = keyGen.generateRandomBytes(16);

        ApplicationVersionEntity version = new ApplicationVersionEntity();
        version.setApplication(application);
        version.setName(versionName);
        version.setSupported(true);
        version.setApplicationKey(BaseEncoding.base64().encode(applicationKeyBytes));
        version.setApplicationSecret(BaseEncoding.base64().encode(applicationSecretBytes));
        version = repositoryCatalogue.getApplicationVersionRepository().save(version);

        CreateApplicationVersionResponse response = new CreateApplicationVersionResponse();
        response.setApplicationVersionId(version.getId());
        response.setApplicationVersionName(version.getName());
        response.setApplicationKey(version.getApplicationKey());
        response.setApplicationSecret(version.getApplicationSecret());
        response.setSupported(version.getSupported());

        return response;
    }

    /**
     * Mark a version with given ID as unsupported
     *
     * @param versionId Version ID
     * @return Response confirming the operation
     * @throws GenericServiceException Thrown when application version does not exist.
     */
    public UnsupportApplicationVersionResponse unsupportApplicationVersion(Long versionId) throws GenericServiceException {

        ApplicationVersionEntity version = findApplicationVersionById(versionId);

        version.setSupported(false);
        version = repositoryCatalogue.getApplicationVersionRepository().save(version);

        UnsupportApplicationVersionResponse response = new UnsupportApplicationVersionResponse();
        response.setApplicationVersionId(version.getId());
        response.setSupported(version.getSupported());

        return response;
    }

    /**
     * Mark a version with given ID as supported
     *
     * @param versionId Version ID
     * @return Response confirming the operation
     * @throws GenericServiceException Thrown when application version does not exist.
     */
    public SupportApplicationVersionResponse supportApplicationVersion(Long versionId) throws GenericServiceException {

        ApplicationVersionEntity version = findApplicationVersionById(versionId);

        version.setSupported(true);
        version = repositoryCatalogue.getApplicationVersionRepository().save(version);

        SupportApplicationVersionResponse response = new SupportApplicationVersionResponse();
        response.setApplicationVersionId(version.getId());
        response.setSupported(version.getSupported());

        return response;
    }

    /**
     * Find application entity by ID.
     * @param applicationId Application ID.
     * @return Application entity.
     * @throws GenericServiceException Thrown when application does not exist.
     */
    private ApplicationEntity findApplicationById(Long applicationId) throws GenericServiceException {
        final Optional<ApplicationEntity> applicationOptional = repositoryCatalogue.getApplicationRepository().findById(applicationId);
        if (!applicationOptional.isPresent()) {
            logger.info("Application not found, application ID: {}", applicationId);
            throw localizationProvider.buildExceptionForCode(ServiceError.INVALID_APPLICATION);
        }
        return applicationOptional.get();
    }

    /**
     * Find application entity by name.
     * @param applicationName Application name.
     * @return Application entity.
     * @throws GenericServiceException Thrown when application does not exist.
     */
    private ApplicationEntity findApplicationByName(String applicationName) throws GenericServiceException {
        final Optional<ApplicationEntity> applicationOptional = repositoryCatalogue.getApplicationRepository().findByName(applicationName);
        if (!applicationOptional.isPresent()) {
            logger.info("Application not found, application name: '{}'", applicationName);
            throw localizationProvider.buildExceptionForCode(ServiceError.INVALID_APPLICATION);
        }
        return applicationOptional.get();
    }

    /**
     * Find application version entity by ID.
     * @param versionId Application version ID.
     * @return Application version entity.
     * @throws GenericServiceException Thrown when application version does not exist.
     */
    private ApplicationVersionEntity findApplicationVersionById(Long versionId) throws GenericServiceException {
        final Optional<ApplicationVersionEntity> applicationVersionOptional = repositoryCatalogue.getApplicationVersionRepository().findById(versionId);
        if (!applicationVersionOptional.isPresent()) {
            logger.info("Application version not found, application version ID: {}", versionId);
            throw localizationProvider.buildExceptionForCode(ServiceError.INVALID_APPLICATION);
        }
        return applicationVersionOptional.get();
    }

}
