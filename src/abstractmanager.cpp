/*
    Quickddit - Reddit client for mobile phones
    Copyright (C) 2014  Dickson Leong

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see [http://www.gnu.org/licenses/].
*/

#include <QtNetwork/QNetworkReply>

#include "abstractmanager.h"

AbstractManager::AbstractManager(QObject *parent) :
    QObject(parent), m_busy(false), m_manager(0), m_request(0)
{
}

bool AbstractManager::isBusy() const
{
    return m_busy;
}

QuickdditManager *AbstractManager::manager()
{
    return m_manager;
}

void AbstractManager::setManager(QuickdditManager *manager)
{
    m_manager = manager;
}

void AbstractManager::setBusy(bool busy)
{
    if (m_busy != busy) {
        m_busy = busy;
        emit busyChanged();
    }
}

APIRequest* AbstractManager::req()
{
    return m_request;
}

void AbstractManager::doRequest(APIRequest::HttpMethod method, const QString &relativeUrl, const char* finishedHandler, const QHash<QString, QString> &parameters)
{
    if (m_request != 0) {
        qWarning("Aborting active network request (Try to avoid!)");
        m_request->disconnect();
        m_request->deleteLater();
        m_request = 0;
    }

    m_request = manager()->createRedditRequest(this, method, relativeUrl, parameters);
    connect(m_request, SIGNAL(finished(QNetworkReply*)), SLOT(onRequestFinished(QNetworkReply*)));
    if (finishedHandler)
        connect(m_request, SIGNAL(finished(QNetworkReply*)), finishedHandler);

    setBusy(true);
}

void AbstractManager::onRequestFinished(QNetworkReply* reply)
{
    Q_UNUSED(reply)

    m_request->deleteLater();
    m_request = 0;

    setBusy(false);
}
