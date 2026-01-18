#include "taskmodel.h"

TasksModel::TasksModel(QObject *parent) : QAbstractListModel(parent) {}

int TasksModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) return 0;
    return static_cast<int>(m_tasks.size());
}

QVariant TasksModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= static_cast<int>(m_tasks.size()))
        return QVariant();

    const TaskItem &item = m_tasks[index.row()];
    if (role == IdRole) return item.id;
    if (role == TitleRole) return item.title;
    if (role == CompletedRole) return item.completed;

    return QVariant();
}

bool TasksModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    if (!index.isValid() || role != CompletedRole) return false;

    m_tasks[index.row()].completed = value.toBool();
    Q_EMIT dataChanged(index, index, QList<int>({role}));
    
    return true;
}

QHash<int, QByteArray> TasksModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "taskId";
    roles[TitleRole] = "title";
    roles[CompletedRole] = "completed";
    return roles;
}

void TasksModel::setTasks(const std::vector<TaskItem> &tasks) {
    beginResetModel();
    m_tasks = tasks;
    endResetModel();
}